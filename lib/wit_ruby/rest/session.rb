## session.rb
## Handles all the neccesary methods to do certain API RESTful calls.
## Documentation from Wit for these methods - https://wit.ai/docs/api

module Wit
  module REST
    class Session
      ## Initialize with the given client.
      def initialize(client)
        @client = client
      end
      ## GET - extracted meaning form a sentence
      def send_message(message)
        ## Recieve unwrapped results
        results = @client.get("/message?q=#{message}")
        return Message.new(results.raw_data, results.restCode, results.path, results.body)
      end

      ## POST - extract meaning from a audio file
      ## Do check the certain documentation of what the specific audio file
      ## should be.
      def send_sound_message(sound)
      end

      ## GET - returns stored message for specific id.
      ## TODO - possibly renaming as it is ambigious compared to send_message.
      ## TODO - Notify Wit.ai as there documentation does not include the stats parameter
      def get_message(message_id)
        results = @client.get("/messages/#{message_id}")
        return Message.new(results.raw_data, results.restCode, results.path, results.body)
      end

      ## GET - returns either a list of intents if no id is given.
      ##     - returns the specific intent of the id given.
      def get_intent(intent_id = nil)

        ## TODO - Raise error if no intents
        return @client.get("/intents")
      end

      ## TODO - look into corpus

      ## GET - returns a list of available entities given this instance with the
      ##       given token if no id is given.
      ##     - returns the specific entity and its parameters with a given id.
      ## TODO - notify Wit.ai to fix their documentations as there is a wrong
      ##      - description.
      def entities(entity_id = nil)

      end

      ## POST - creates a new entity with the given attributes.
      def create_entity(new_entity)
      end

      ## PUT - updates a given entity with the specific entity id.
      def update_entity(entity_id)
      end

      ## DELETE - deletes the given entity with the entity id.
      def delete_entity(entity_id)
      end

      ## POST - adds the possible value into the list of values for the given
      ##      - entity with the id.
      def add_value(entity_id, new_value)

      end

      ## DELETE - deletes the value from the list of values in the entity with
      ##        - with the given value.
      def delete_value(entity_id, delete_value)

      end

      ## POST - adds a new expression to the value of the entity.
      def add_expression(entity_id, value, new_expression)

      end

      ## DELETE - deleetes the expression in the value of the entity.
      def delete_expression(entity_id, value, expression)

      end

      ## Used to refresh the results from the given results.
      def refresh_results(result)
        ## Call client with refresh results method
        return @client.request_from_result(result.restCode, result.path, result.body)
      end

      ## Used to refresh the last response given from the last request.
      def refresh_last
        last_result = @client.last_result
        return @client.request_from_result(last_result.restCode, last_result.path, last_result.body)
      end


    end
  end
end
