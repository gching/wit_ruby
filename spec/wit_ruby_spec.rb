require 'spec_helper'


describe Wit do
  let (:message) {"Hi there!"}


  it '.send_message(message)' do
    pending
  	#results = Wit.send_message(message)
  #  expect(results).to be_a Wit::Results
  end

  it ".send_sound_message(soundwave)" do
    pending
  end

  it ".message(message_id)" do
    pending
  end

  ## Intent_id could be intent id or the name of the intent.
  it ".intent(intent_id)" do
    pending
  end

  ## Returns the list of entities in the current session.
  it ".entities()" do
    pending
  end

  ## Returns the specific entity with the meaning.
  it ".entities(entity_id)" do
    pending
  end

  ## Creates new entity. Requiries JSON.
  it ".create_entity(new_entity)" do
    pending
  end

  it ".update_entitiy(entity_id)" do
    pending
  end

  it ".delete_entity(entity_id)" do
    pending
  end

  ## Adds a value to the given entitiy. Requires JSON.
  it ".add_value(entity_id, new_value)" do
    pending
  end

  it ".delete.value(entity_id)" do
    pending
  end

  ## Adds an expression to the given value in the entity. Requires JSON.
  it ".add_expression(entity_id, value, new_expression)" do
    pending
  end

  ## Deletes the given experession in the value of the entity.
  it ".delete_expression(entity_id, value, expression)" do
    pending
  end

end
