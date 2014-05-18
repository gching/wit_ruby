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

    it ".update_entity(entity_id)" do
      randSession.should respond_to(:update_entity)
    end

    it ".delete_entity(entity_id)" do
      randSession.should respond_to(:delete_entity)
    end

    it ".add_value(entity_id, new_value)" do
      randSession.should respond_to(:add_value)
    end

    it ".delete_value(entity_id, delete_value)" do
      randSession.should respond_to(:delete_value)
    end

    it ".add_expression(entity_id, value, new_expression)" do
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
      VCR.insert_cassette 'get_entities'
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
        ## TODO - tell WIT.AI there documentation is wrong as they have name and id switched.
        expect(get_entity.name).to eql(get_entities[0].split("$")[1])
      end

    end
  end

  describe "posting entities" do
    let(:json) {%({
      "doc": "A city that I like",
      "id": "favorite_city",
      "values": [
        {
          "value": "Paris",
          "expressions": ["Paris", "City of Light", "Capital of France"]
        }
      ]
    })}
    let(:new_body) {Wit::REST::BodyJson.new(MultiJson.load(json))}
    let(:resulting_post) {session.create_entity(new_body)}

    before do
      VCR.insert_cassette 'post_entity'
    end
    after do
      VCR.eject_cassette
    end
    it "should pass and return Result with correct id" do
      expect(resulting_post.class).to eql(Wit::REST::Result)
      expect(resulting_post.name).to eql("favorite_city")
    end

  end


end
