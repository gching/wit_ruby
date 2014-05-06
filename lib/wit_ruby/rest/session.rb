module Wit
  module REST
    class Session
      def initialize(client)
        @client = client
      end

      def send_message(message)
         return @client.get("/message?q=#{message}")
      end

      def send_sound_message(sound)
      end

      def get_message(message_id)

      end

      def get_intent(intent_id)
      end

      def entities

      end

      def create_entity(new_entity)
      end

      def update_entity(entity_id)
      end

      def delete_entity(entity_id)
      end

      def add_value(entity_id, new_value)

      end

      def delete_value(entity_id)

      end

      def add_expression(entity_id, value, new_expression)

      end

      def delete_expression(entity_id, value, expression)

      end



    end
  end
end
