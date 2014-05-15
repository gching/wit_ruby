## intent.rb
## Wrapper for the superclass Result for intent specific results

module Wit
  module REST

    ## Intent wrapper for intent specific results
    class Intent < Result

      ## Performs additional instance variable generation for expressions.
      ##
      ## @param resultData [Hash] data from the call.
      ## @param requestRest [String] rest code for the call.
      ## @param requestPath [String] request path for the call.
      ## @param requestBody [Hash] body of the call.
      ## @return [Wit::REST::Expression] object that holds the intent result.
      def initialize(resultData, requestRest=nil, requestPath=nil, requestBody=nil)
        super
        @expressions = @rawdata["expressions"].map do |expression_hash|
          Expression.new(expression_hash)
        end
      end

      ## Return the list of expressions as array of expression objects
      ##
      ## @return [Array] expressions in this intent.
      def expressions
        return @expressions
      end

      ## Return the expression bodies as an array of strings.
      ##
      ## @return [Array] body of each expression.
      def expression_bodies
        expression_bodies_arr = Array.new
        @expressions.each do |expression|
          expression_bodies_arr << expression.body
        end
        return expression_bodies_arr
      end

      ## Return entities used with there id as an array of strings.
      ##
      ## @return [Array] entity names that are used in this intent.
      def entities_used
        entities_arr = Array.new
        @entities.each do |entity|
          entities_arr << entity.id unless entities_arr.include?(entity.id)
        end
        return entities_arr
      end


    end

    ## MultiIntent wraps around results that are an array with intents.
    class MultiIntent < Result

      ## Generates instance variable that holds intents as Wit::REST::Result.
      ##
      ## @param resultData [Hash] data from the call.
      ## @param requestRest [String] rest code for the call.
      ## @param requestPath [String] request path for the call.
      ## @param requestBody [Hash] body of the call.
      ## @return [Wit::REST::MultiIntent] object that holds the array of intents as result objects.
      def initialize(resultData, requestRest=nil, requestPath=nil, requestBody=nil)
        super
        @intents = @rawdata.map do |intent|
          Result.new(intent)
        end
      end

      ## Overide that assists in calling the proper index in the array of intent results.
      ##
      ## @param num [Integer] index of the array of Wit::REST::Result.
      ## @return [Wit::REST::Result] specific intent at the index given.
      def [](num)
        @intents[num]
      end

      ## Assists in going through each intent in the instance variable.
      ##
      ## @return [Wit::REST::Result] lambda that provides each specific intent.
      def each
        @intents.each do |intent|
          lambda{intent}
        end
      end

    end
  end
end
