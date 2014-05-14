## session_spec.rb
## Used to test lib/wit_ruby/rest/session_spec.rb

require 'spec_helper'

describe Wit::REST::Session do
  let(:auth) {"randomAuth"}
  let(:randClient) {"randomClient"}
  let(:message) {"Hi"}
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

    it "get_intent(intent_id = nil)" do
      randSession.should respond_to(:get_intent)
    end

    it ".entities(entity_id = nil)" do
      randSession.should respond_to(:entities)
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



        it "must be able refresh and resend the call to the API given the result class" do
          expect{session.refresh_results(@results)}.to raise_error(Timeout::Error)
        end

        it "should be able to refresh the last result" do
          expect{session.refresh_last}.to raise_error(Timeout::Error)
        end



    end

  end


  describe "Geting message info" do
    let(:sent_message_result) {session.send_message(message)}
    let(:sent_message_id) {sent_message_result.msg_id}
    let(:resulting_message) {session.get_message(sent_message_id)}

    before do
      VCR.insert_cassette 'get_message', record: :new_episodes
    end
    after do
      VCR.eject_cassette
    end

    it "should get back the same message and have the same has as the sent message results" do
      expect(resulting_message.msg_id).to eql(sent_message_id)
      expect(resulting_message.msg_body).to eql(sent_message_result.msg_body)
    end

  end

  describe "Get intents" do
    let(:get_intent) {session.get_intent}

    before do
      VCR.insert_cassette 'get_intents', record: :new_episodes
    end
    after do
      VCR.eject_cassette
    end
    it "should have returned an array" do
      expect(get_intent.raw_data.class).to eql(Array)
    end
  end

end
