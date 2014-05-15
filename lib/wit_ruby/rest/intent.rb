## intent.rb
## Wrapper for the superclass Result for intent specific results

module Wit
  module REST
    class Intent < Result


      def initialize(resultData, requestRest=nil, requestPath=nil, requestBody=nil)
        super
      #  @entities = @rawdata["entities"].map do |entity_hash|
        #  Entity.new(entity_hash)
      #  end
        @expressions = @rawdata["expressions"].map do |expression_hash|
          Expression.new(expression_hash)
        end
      end

      ## Return the list of expressions as array of expression objects
      def expressions
        return @expressions
      end

      ## Return the expression bodies as an array of strings.
      def expression_bodies
        expression_bodies_arr = Array.new
        @expressions.each do |expression|
          expression_bodies_arr << expression.body
        end
        return expression_bodies_arr
      end

      ## Return entities used with there id as an array of strings.
      def entities_used
        entities_arr = Array.new
        @entities.each do |entity|
          entities_arr << entity.id unless entities_arr.include?(entity.id)
        end
        return entities_arr
      end


    end
  end
end
