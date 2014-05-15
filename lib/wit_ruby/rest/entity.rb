## entity.rb
## Wrapper for entity results.

module Wit
  module REST

    ## Encompasses entity results.
    class Entity < Result

    end

    ## Internal wrapper for multiple entities for a given result.
    class MultiEntity
      ## Creates an instance that holds array of intents.
      ##
      ## @param resultData [Array] array of hashes of intents.
      ## @return [Wit::REST::MultiEntity] with instance variable of Array of intents.
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
  end
end
