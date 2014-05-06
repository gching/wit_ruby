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

    ## Intent_id could be intent id or the name of the intent.
    it "get_intent(intent_id = nil)" do
      randSession.should respond_to(:get_intent)
    end

    ## Returns the list of entities in the current randSession.
    it ".entities(entity_id = nil)" do
      randSession.should respond_to(:entities)
    end

    ## Returns the specific entity with the meaning.
    #it ".entities(entity_id)" do
    #  pending
    #end

    ## Creates new entity. Requiries JSON.
    it ".create_entity(new_entity)" do
      randSession.should respond_to(:create_entity)
    end

    it ".update_entity(entity_id)" do
      randSession.should respond_to(:update_entity)
    end

    it ".delete_entity(entity_id)" do
      randSession.should respond_to(:delete_entity)
    end

    ## Adds a value to the given entitiy. Requires JSON.
    it ".add_value(entity_id, new_value)" do
      randSession.should respond_to(:add_value)
    end

    it ".delete_value(entity_id, delete_value)" do
      randSession.should respond_to(:delete_value)
    end

    ## Adds an expression to the given value in the entity. Requires JSON.
    it ".add_expression(entity_id, value, new_expression)" do
      randSession.should respond_to(:add_expression)
    end

    ## Deletes the given experession in the value of the entity.
    it ".delete_expression(entity_id, value, expression)" do
      randSession.should respond_to(:delete_expression)
    end
  end

################# Functionalities with API mockup ###########################

  describe "Sending message" do
    let(:result) { session.send_message(message)}

    before do
      VCR.insert_cassette 'message', record: :new_episodes
    end
    after do
      VCR.eject_cassette
    end

    it "should return a hash" do
      result.class.should be_eql Hash
    end

  end

end
