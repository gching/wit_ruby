## message.rb
## Wraps around results, specifically messages.
module Wit
  module REST



    class Message < Result

      def confidence
        outcome["confidence"]
      end

      def intent
        outcome["intent"]
      end

      def entity_names
        entity_arr = Array.new
        outcome["entities"].each_key do |key|
          entity_arr << key
        end
        return entity_arr
      end

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
