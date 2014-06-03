## entity.rb
## Wrapper for entity results.

module Wit
  module REST

    ## Encompasses entity results.
    class Entity < Result

    end

    ## Internal wrapper for multiple entities for a given result.
    class EntityArray
      ## Creates an instance that holds array of intents.
      ##
      ## @param resultData [Array] array of hashes of entity values.
      ## @return [Wit::REST::MultiEntity] with instance variable of Array of each entity value.
      def initialize(resultData)

        entity_arr = Array.new
        resultData.each do |entity|
          entity_arr << Entity.new(entity)
        end
        @entities = entity_arr
      end

      ## Allow for index calls to the specific intents in the instance.
      ##
      ## @param num [Integer] index of the specific intent.
      def [](num)
        @entities[num]
      end

    end

    ## Wrapper for array of entities as strings. Inherits from Results so it can
    ## be refreshed.
    ## @todo Propagate these methods into Result
    class MultiEntity < Result

      ## Generates instance variable that holds list of entities as strings in array.
      ##
      ## @param resultData [Hash] data from the call.
      ## @param requestRest [String] rest code for the call.
      ## @param requestPath [String] request path for the call.
      ## @param requestBody [Hash] body of the call.
      ## @return [Wit::REST::MultiIntent] object that holds the array of intents as result objects.
      def initialize(resultData, requestRest=nil, requestPath=nil, requestBody=nil)
        ## Pass in empty hash to default to method missing for everything not defined here.
        super({}, requestRest, requestPath, requestBody)
        @entities = resultData
      end

      ## Overide that assists in calling the proper index in the array of entity strings.
      ##
      ## @param num [Integer] index of the array of Strings
      ## @return [Wit::REST::Result] specific entity at the index given.
      def [](num)
        @entities[num]
      end

      ## Assists in going through each entity string in the instance variable.
      ##
      ## @return [String] lambda that provides each specific entity id.
      def each
        @entities.each do |entity|
          lambda{entity}
        end
      end

    end


  end
end
