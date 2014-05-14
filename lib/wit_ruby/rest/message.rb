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
    end




  end
end
