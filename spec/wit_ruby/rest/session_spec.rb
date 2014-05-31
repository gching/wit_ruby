## session_spec.rb
## Used to test lib/wit_ruby/rest/session_spec.rb

require 'spec_helper'

describe Wit::REST::Session do
  let(:auth) {"randomAuth"}
  let(:randClient) {"randomClient"}
  let(:message) {"Hi"}
  let(:rand_hash) {{"a" => "a", "b" => "b"}}
  let(:randSession) {Wit::REST::Session.new(randClient)}
  let(:session) {Wit::REST::Client.new.session}
  random_name = (0...10).map { ('a'..'z').to_a[rand(26)] }.join


  ## Testing for method response
  describe "Default attributes and method definitions" do
    it "should have a client instance variable" do
      randSession.instance_variable_get("@client").should be_eql randClient
    end

    it '.send_message(message)' do
      randSession.should respond_to(:send_message)
    end

    it ".send_sound_message(soundwave)" do
      randSession.should respond_to(:send_sound_message)
    end

    it ".get_message(message_id)" do
      randSession.should respond_to(:get_message)
    end

    it "get_intents(intent_id = nil)" do
      randSession.should respond_to(:get_intents)
    end

    it "get.entities(entity_id = nil)" do
      randSession.should respond_to(:get_entities)
    end

    it ".create_entity(new_entity)" do
      randSession.should respond_to(:create_entity)
    end

    it ".update_entity(entity_id, update_entity_data)" do
      randSession.should respond_to(:update_entity)
    end

    it ".delete_entity(entity_id)" do
      randSession.should respond_to(:delete_entity)
    end

    it ".add_value(entity_name, new_value)" do
      randSession.should respond_to(:add_value)
    end

    it ".delete_value(entity_id, delete_value)" do
      randSession.should respond_to(:delete_value)
    end

    it ".add_expression(new_expression_with_id_and_value)" do
      randSession.should respond_to(:add_expression)
    end

    it ".delete_expression(entity_id, value, expression)" do
      randSession.should respond_to(:delete_expression)
    end
  end



################# Functionalities with API mockup ###########################

  describe "Sending message" do
    let(:result) {session.send_message(message)}
    let(:result_data){result.raw_data}

    before do
      VCR.insert_cassette 'message', record: :new_episodes
    end
    after do
      VCR.eject_cassette
    end

    it "should return an object of class Message" do
      expect(result.class).to eql(Wit::REST::Message)
    end

    it "should have a message id method" do
      expect(result.msg_id).to eql(result_data["msg_id"])
    end




    describe "caching" do
      ## Use webmock to disable the network connection after the api request
      ## We use the simple sending message method for testing.
      before do
        @results = session.send_message(message)
        stub_request(:any, /api.wit.ai/).to_timeout
      end
      let(:random_result) {Wit::REST::Result.new(rand_hash)}


        it "must be able refresh and resend the call to the API given the result class" do
          expect{session.refresh_results(@results)}.to raise_error(Timeout::Error)
        end

        it "should be able to refresh the last result" do
          expect{session.refresh_last}.to raise_error(Timeout::Error)
        end

        it "should not be able to refresh a not refreshable object" do
          expect{session.refresh_results("random_class")}.to raise_error(Wit::REST::NotRefreshable)
          expect{session.refresh_results(random_result)}.to raise_error(Wit::REST::NotRefreshable)
        end



    end

  end


  describe "Geting message info" do
    let(:sent_message_result) {session.send_message(message)}
    let(:sent_message_id) {sent_message_result.msg_id}
    before do
      VCR.insert_cassette 'get_message', record: :once
    end
    after do
      VCR.eject_cassette
    end
    describe "Getting back message info " do

      before do
        @resulting_message = session.get_message(sent_message_id)
      end

      it "should get back the same message and have the same has as the sent message results" do
        expect(@resulting_message.msg_id).to eql(sent_message_id)
        expect(@resulting_message.msg_body).to eql(sent_message_result.msg_body)
      end
    end
  end

  describe "Get intents" do
    let(:get_intent_arr) {session.get_intents}


    before do
      VCR.insert_cassette 'get_intents', record: :new_episodes
    end
    after do
      VCR.eject_cassette
    end
    it "should have returned an array of intents in class MultiIntent if not given an id" do
      expect(get_intent_arr.class).to eql(Wit::REST::MultiIntent)
      expect(get_intent_arr[0].class).to eql(Wit::REST::Result)
    end

  end

  describe "Get specific intent" do
    let(:get_intent_arr) {session.get_intents}
    let(:intent_id) {get_intent_arr[0].id}
    let(:intent_name) {get_intent_arr[0].name}
    let(:get_intent_id) {session.get_intents(intent_id)}
    let(:get_intent_name) {session.get_intents(intent_name)}
    before do
      VCR.insert_cassette 'get_intent_specific', record: :new_episodes
    end
    after do
      VCR.eject_cassette
    end

    it "should return an intent result if given an id or name and must be same results" do
      expect(get_intent_id.class).to eql(Wit::REST::Intent)
      expect(get_intent_name.class).to eql(Wit::REST::Intent)
      expect(get_intent_id.id).to eql(get_intent_name.id)
    end

  end


  describe "getting entities" do
    let(:get_entities) {session.get_entities}
    let(:get_entity) {session.get_entities(get_entities[0])}

    before do
      VCR.insert_cassette 'get_entities', record: :new_episodes
    end
    after do
      VCR.eject_cassette
    end

    describe "get list of entities" do

        it "should return an array of used entities as strings" do
          expect(get_entities.class).to eql(Wit::REST::EntityArray)
          expect(get_entities[0].class).to eql(String)
        end

    end

    describe "get specific entity from id" do


      it "should return an entity class with same id" do
        expect(get_entity.class).to eql(Wit::REST::Entity)
        ## @todo tell WIT.AI there documentation is wrong as they have name and id switched.
        expect(get_entity.name).to eql(get_entities[0].split("$")[1])
      end

    end
  end

  describe "posting, deleting, updating entities" do
    let(:json) {%({
      "doc": "A city that I like",
      "id": "#{random_name}",
      "values": [
        {
          "value": "Paris",
          "expressions": ["Paris", "City of Light", "Capital of France"]
        }
      ]
    })}
    let(:no_id_hash) {{"doc" => "AMAZING", "values" => [
      {
        "value" => "Paris",
        "expressions" => ["Paris", "City of Light", "Capital of France"]
      }
    ] }}
    let(:new_body) {Wit::REST::BodyJson.new(MultiJson.load(json))}
    let(:no_id_body){Wit::REST::BodyJson.new(no_id_hash)}
    let(:resulting_post) {session.create_entity(new_body)}
    let(:resulting_post_name) {resulting_post.name}
    let(:resulting_post_id) {resulting_post.id}


    before do
      VCR.insert_cassette 'post_update_delete_entity', record: :new_episodes
    end
    after do
      VCR.eject_cassette
    end
    it "should raise error when the BodyJson does not have an ID parameter" do
      expect{session.create_entity(no_id_body)}.to raise_error(Wit::REST::NotCorrectSchema)
    end

    it "should pass and return Result" do
      expect(resulting_post.class).to eql(Wit::REST::Result)
    end

    describe "updating entities" do
      let(:json_two) {%({
        "doc": "A city that I like",
        "values": [
          {
            "value": "Paris",
            "expressions": ["Paris", "City of Light", "Capital of France"]
          },
          {
              "value": "Seoul",
              "expressions": ["Seoul", "Kimchi paradise"],
              "metadata":"city_343"
          }
        ]
      })}
      let(:update_body) {Wit::REST::BodyJson.new(MultiJson.load(json_two))}
      let(:resulting_update) {session.update_entity(resulting_post_name, update_body)}

      it "should return a Result class" do
        expect(resulting_update.class).to eql(Wit::REST::Result)
      end
    end

    describe "deleting entities" do
      let(:resulting_delete) {session.delete_entity(resulting_post_name)}

      it "should pass and return Result with the same deleted id" do
        expect(resulting_delete.class).to eql(Wit::REST::Result)
        expect(resulting_delete.deleted).to eql(resulting_post_id)
      end

    end

  end


  describe "creating and deleting value for an entity" do
    let(:entity_json) {
      %({"id": "#{random_name}"})
    }
    let(:entity_body) {Wit::REST::BodyJson.new(MultiJson.load(entity_json))}
    #let(:resulting_add_value) {session.add_value(@resulting_entity_name, with_value_added_body)}


    before :each do
      VCR.insert_cassette 'add_delete_value', record: :new_episodes
      @resulting_entity = session.create_entity(entity_body)
      @resulting_entity_name = @resulting_entity.name
      @resulting_value_name = @resulting_entity_name
      @body_for_value_insert = Wit::REST::BodyJson.new(id: @resulting_entity_name)
      @body_with_id_and_value = @body_for_value_insert.add_value(@resulting_value_name)
      @resulting_add_value = session.add_value(@body_with_id_and_value)
      @resulting_delete_value = session.delete_value(@resulting_entity_name, @resulting_value_name)
      @no_id = Wit::REST::BodyJson.new.add_value(@resulting_value_name)
      @no_value = Wit::REST::BodyJson.new(id: @resulting_entity_name)
    end
    after :each do
      session.delete_entity(@resulting_entity_name)
      VCR.eject_cassette
    end
    describe "creation" do
      it "should return a Result class after creation" do
        expect(@resulting_add_value.class).to eql(Wit::REST::Result)
      end

      it "should have the new value inserted" do
        expect(@resulting_add_value.values[0]["value"]).to eql(@resulting_value_name)
      end

      it "should raise an error for an incorrect BodyJson with no id or value " do
        expect{session.add_value(@no_id)}.to raise_error(Wit::REST::NotCorrectSchema)
        expect{session.add_value(@no_value)}.to raise_error(Wit::REST::NotCorrectSchema)
      end
    end

    describe "deletion" do
      it "should return a Result class after deletion" do
        expect(@resulting_delete_value.class).to eql(Wit::REST::Result)
      end

      it "should have the value deleted" do
        expect(@resulting_delete_value.deleted).to eql(@resulting_value_name)
      end
    end
  end

  describe "creating and deleting expression from a value" do
    let(:entity_body) {Wit::REST::BodyJson.new(id: random_name)}
    before :each do
      VCR.insert_cassette 'add_delete_expression', record: :new_episodes
      entity_creation = session.create_entity(entity_body)
      @entity_value_expression_name = entity_creation.name
      session.add_value(Wit::REST::BodyJson.new(id: @entity_value_expression_name).add_value(@entity_value_expression_name))
      @expression_creation = session.add_expression(Wit::REST::BodyJson.new(id:        @entity_value_expression_name).add_value(@entity_value_expression_name).add_expression(@entity_value_expression_name, @entity_value_expression_name))
      @expression_deletion = session.delete_expression(@entity_value_expression_name, @entity_value_expression_name, @entity_value_expression_name)
    end
    after :each do
      session.delete_value(@entity_value_expression_name, @entity_value_expression_name)
      session.delete_entity(@entity_value_expression_name)
      VCR.eject_cassette
    end

    describe "addition" do
      it "should return a Result class" do
        expect(@expression_creation.class).to eql(Wit::REST::Result)
      end
      it "should have the expression added" do
        expect(@expression_creation.values[0]["expressions"][0]).to eql(@entity_value_expression_name)
      end
    end

    describe "deletion" do
      it "should return a Result class" do
        expect(@expression_deletion.class).to eql(Wit::REST::Result)
      end
      it "should have deleted as the expression name" do
        expect(@expression_deletion.deleted).to eql(@entity_value_expression_name)
      end
    end

  end


end
