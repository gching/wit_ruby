## session_spec.rb
## Used to test lib/wit_ruby/rest/session_spec.rb

require 'spec_helper'

describe Wit::REST::Session do
  let(:auth) {"randomAuth"}
  let(:client) {"randomClient"}
  let(:message) {"Hi"}
  let(:session) {Wit::REST::Session.new(client)}

## Testing for method response
begin
  it "should have a client instance variable" do
    session.instance_variable_get("@client").should be_eql client
  end

  it '.send_message(message)' do
    session.should respond_to(:send_message)
  end

  it ".send_sound_message(soundwave)" do
    session.should respond_to(:send_sound_message)
  end

  it ".get_message(message_id)" do
    session.should respond_to(:get_message)
  end

  ## Intent_id could be intent id or the name of the intent.
  it ".get_intent(intent_id)" do
    session.should respond_to(:get_intent)
  end

  ## Returns the list of entities in the current session.
  it ".entities" do
    session.should respond_to(:entities)
  end

  ## Returns the specific entity with the meaning.
  #it ".entities(entity_id)" do
  #  pending
  #end

  ## Creates new entity. Requiries JSON.
  it ".create_entity(new_entity)" do
    session.should respond_to(:create_entity)
  end

  it ".update_entity(entity_id)" do
    session.should respond_to(:update_entity)
  end

  it ".delete_entity(entity_id)" do
    session.should respond_to(:delete_entity)
  end

  ## Adds a value to the given entitiy. Requires JSON.
  it ".add_value(entity_id, new_value)" do
    session.should respond_to(:add_value)
  end

  it ".delete_value(entity_id)" do
    session.should respond_to(:delete_value)
  end

  ## Adds an expression to the given value in the entity. Requires JSON.
  it ".add_expression(entity_id, value, new_expression)" do
    session.should respond_to(:add_expression)
  end

  ## Deletes the given experession in the value of the entity.
  it ".delete_expression(entity_id, value, expression)" do
    session.should respond_to(:delete_expression)
  end
end

## Functionalities with API mockup

begin
end



end
