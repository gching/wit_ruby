## message.rb
## Wraps around results, specifically messages.
module Wit
  module REST


    ## Message wrapper for message specific results.
    class Message < Result

      ## Returns the confidence of the message results.
      ##
      ## @return [Float] confidence in the message for the intent.
      def confidence
        outcome["confidence"]
      end

      ## Returns the intent that this message corresponded to.
      ##
      ## @return [String] intent name that this message corrsponded to.
      def intent
        outcome["intent"]
      end

      ## Generates Array of the names of each entity in this message.
      ##
      ## @return [Array] names of each entity
      def entity_names
        entity_arr = Array.new
        outcome["entities"].each_key do |key|
          entity_arr << key
        end
        return entity_arr
      end

      ## Checks if the method is one of the keys in the hash. Overides the one
      ## in Wit::REST::Result as it might correspond to a given entity.
      ## If it is then we can return the given value.
      ## If not, then go to method_missing in Wit::REST::Result.
      ##
      ## @param possible_key [Symbol] possible method or key in the hash or entity.
      ## @return [Class] depending on the given results in the data.
      def method_missing(possible_key, *args, &block)
        if @rawdata["outcome"]["entities"].has_key?(possible_key.to_s)
          entity_value = @rawdata["outcome"]["entities"][possible_key.to_s]
          entity_value.class == Hash ? Entity.new(entity_value) : MultiEntity.new(entity_value)
        else
          super
        end
      end


    end
  end
end
