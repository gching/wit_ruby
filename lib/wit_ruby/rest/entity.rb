## entity.rb
## Wrapper for entity results.

module Wit
  module REST
    class Entity < Result

    end

    class MultiEntity
      def initialize(resultData)

        entity_arr = Array.new
        resultData.each do |entity|
          entity_arr << Entity.new(entity)
        end
        @entities = entity_arr
      end

      def [](num)
        @entities[num]
      end

    end
  end
end
