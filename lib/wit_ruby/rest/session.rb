## session.rb
## Handles all the neccesary methods to do certain API RESTful calls.
## Documentation from Wit for these methods - https://wit.ai/docs/api

module Wit
  module REST
    class Session
      ## Initialize with the given client.
      ##
      ## @param client [Wit::REST::Client] client of the connection
      def initialize(client)
        @client = client
      end
      ## GET - extracted meaning from a sentence.
      ##
      ## @param message [String] sentence being examined from API.
      ## @return [Wit::REST::Message] message results from API.
      def send_message(message)
        ## Recieve unwrapped results
        results = @client.get("/message?q=#{message}")
        return return_with_class(Wit::REST::Message, results)
      end

      ## POST - extract meaning from a audio file
      ## Do check the certain documentation of what the specific audio file
      ## should be.
      ##
      ## @param sound [String] path to sound file.
      def send_sound_message(sound)
      end

      ## GET - returns stored message for specific id.
      ##
      ## @param message_id [String] message id of message in API servers.
      ## @return [Wit::REST::Message] message results from the given id.
      ## @todo possibly renaming as it is ambigious compared to send_message.
      ## @todo Notify Wit.ai as there documentation does not include the stats parameter
      def get_message(message_id)
        results = @client.get("/messages/#{message_id}")

        return return_with_class(Wit::REST::Message, results)
      end

      ## GET - returns either a list of intents if no id is given.
      ##     - returns the specific intent of the id given.
      ##
      ## @param intent_indicator [String] the id or name of the intent
      ## @return [Wit:REST::Intent] [Wit::REST::MultiIntent] results of intent call to API.
      ## @todo Set test for raising error.
      def get_intents(intent_indicator = nil)
        ## No specific id, so get list of intents or specific id, return it as Intent object
        results = intent_indicator.nil? ? @client.get("/intents") : @client.get("/intents/#{intent_indicator}")

        ## If it is empty, raise an empty error.
        raise IsEmpty.new("The returned intents / intent is empty.") if results.empty?
        ## Same concept but wrap it around proper object
        returnObject = intent_indicator.nil? ? MultiIntent : Intent
        return return_with_class(returnObject, results)

      end

      ## TODO - look into corpus

      ## GET - returns a list of available entities given this instance with the
      ##       given token if no id is given.
      ##     - returns the specific entity and its parameters with a given id.
      ## @param entity_id [String] entity id for specific retrieval
      ## @return [Wit::REST::EntityArray] [Wit::REST::Entity] results and returned in either wrapper
      ## @todo notify Wit.ai to fix their documentations as there is a wrong description.
      def get_entities(entity_id = nil)
        ## No specific id, so get list of entities
        results = entity_id.nil? ? @client.get("/entities") : @client.get("/entities/#{entity_id}")
        ## Same concept but wrap it properly if neccessary.
        returnObject = entity_id.nil? ? EntityArray : Entity

        return return_with_class(returnObject, results)

      end

      ## POST - creates a new entity with the given attributes.
      ##
      ## @param new_entity [Wit::REST::BodyJson] object with data to be sent over to API.
      ## @return [Wit::REST::Result] results of the posting of the new entity.
      def create_entity(new_entity)

        ## Checks to make sure it has an id, if not, raise error.
        if new_entity.id.nil?
          raise NotCorrectSchema.new("The current BodyJson object passed in does not have an \"id\" defined.")
        end
        return @client.post("/entities", new_entity.json)
      end


      ## PUT - updates a given entity with the specific entity id and BodyJson data.
      ##
      ## @param entity_id [String] entity id that will be updated.
      ## @param update_entity_data [Wit::REST::BodyJson] new data that will update the entity.
      ## @return [Wit::REST::Result] results of updating the entity
      ## @todo notify Wit.ai to return back the updated entity results.
      def update_entity(entity_id, update_entity_data)
        return @client.put("/entities/#{entity_id}", update_entity_data.json)
      end

      ## DELETE - deletes the given entity with the entity id.
      ##
      ## @param entity_id [String] entity id that is going to be deleted.
      ## @return [Wit::REST::Result] results of the deletion of the entity
      def delete_entity(entity_id)
        return @client.delete("/entities/#{entity_id}")
      end

      ## POST - adds the possible value into the list of values for the given
      ##      - entity with the id.
      ##
      ## @param new_value_with_entity [Wit::REST::BodyJson] includes the new value and entity name as ID.
      ## @return [Wit::REST::Result] the results of the addition of the value
      ## @todo restrict to only one value in BodyJson
      ## @todo notify wit.ai that documentation is off.
      def add_value(new_value_with_entity)
        ## Makes sure values exist and has a value and id as well.
        if new_value_with_entity.id.nil? || new_value_with_entity.one_value_to_json == "null"
          raise NotCorrectSchema.new("The current BodyJson object passed in does not have either an \"id\" or a \"value\" defined.")
        end
        return @client.post("/entities/#{new_value_with_entity.id}/values",  new_value_with_entity.one_value_to_json)
      end

      ## DELETE - deletes the value from the list of values in the entity with
      ##        - with the given value.
      ## @param entity_name [String] name of entity that will have value deleted
      ## @param delete_value [String] name of value to be deleted
      ## @return [Wit::REST::Result] results of the deletion of the value.
      def delete_value(entity_name, delete_value)
        return @client.delete("/entities/#{entity_name}/values/#{delete_value}")
      end

      ## POST - adds a new expression to the value of the entity.
      ##
      ## @param new_expression_with_id_and_value [Wit::REST::BodyJson] includes new expression for said ID and value.
      ## @return [Wit::REST::Result] results of the addition of the expression
      def add_expression(new_express)
        ## Get the value that will had the expression inserted
        ## If it does not exist, raise an error
        value = new_express.values[0]["value"]
        return @client.post("/entities/#{new_express.id}/values/#{value}/expressions", new_express.one_expression_to_json(value))
      end

      ## DELETE - deletes the expression in the value of the entity.
      ##
      ## @param entity_id [String] entity id that will have the expression deleted.
      ## @param value [String] value name that will have the expression deleted.
      ## @param expression [String] expression that will be deleted.
      ## @return [Wit::REST::Result] results of the deletion of the given expression.
      def delete_expression(entity_id, value, expression)
        return @client.delete("/entities/#{entity_id}/values/#{value}/expressions/#{expression}")
      end

      ## Used to refresh the results from the given results. Only applicable to result objects that directly
      ## came from the session.
      ##
      ## @param result [Wit::REST::Result] result from a call that is going to be refreshed.
      ## @return [Wit::REST::Result] result back that will be wrapped around it's specific wrapper object
      def refresh_results(result)
        ## Call client with refresh results method
        ## Checks to see if its part of the specified objects in the Wit module
        ## Checks to see if the object is refreshable
        ## If it isn't part of one of these two, then raise error for not being refreshable.
        result_class = result.class
        unless  result_class.name.split("::")[0] == "Wit" && result.refreshable?
          raise NotRefreshable.new(%(The inputted object with class "#{result.class}" is not refreshable.))
        end
        refreshed_result = @client.request_from_result(result.restCode, result.restPath, result.restBody)
        return return_with_class(result_class, refreshed_result)
      end

      ## Used to refresh the last response given from the last request.
      ##
      ## @return [Wit::REST::Result] refreshed result from last result
      ## @todo fix wrapper
      def refresh_last
        last_result = @client.last_result
        return @client.request_from_result(last_result.restCode, last_result.restPath, last_result.restBody)
      end

      private
      ## Used to return using the given return class and results.
      ##
      ## @param return_class return class for the specific method.
      ## @param results [Wit::REST::Result] holding the specific results from client.
      def return_with_class(return_class, results)
        return return_class.new(results.raw_data, results.restCode, results.restPath, results.restBody)
      end

    end

    ## Raised when the given result object cannot be refreshed.
    ##
    class NotRefreshable < Exception; end

    ## Raised when the given result object does not have required parameters.
    ##
    class NotCorrectSchema < Exception; end

    ## Raised when the returned result object is empty.
    class IsEmpty < Exception; end

  end
end
