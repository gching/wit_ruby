## result.rb
## Specifies superclass that handles the results given from each RESTful API call.


module Wit
  module REST

    ## Wrapper for all results that is returned by the session and API calls.
    class Result


      ## Instantiates with a given hash and its REST parameters.
      ##
      ## @param resultData [Hash] data from the call.
      ## @param requestRest [String] rest code for the call.
      ## @param requestPath [String] request path for the call.
      ## @param requestBody [Hash] body of the call.
      ## @return [Wit::REST::Result] object that holds result information.
      def initialize(resultData, requestRest=nil, requestPath=nil, requestBody=nil)
        @rawdata = resultData
        @requestRest = requestRest
        @requestPath = requestPath
        @requestBody = requestBody
        ## Sets self class to be the last index of the split class name.
        @selfClass = self.class.name.split("::")[-1]
        ## Setup lists / instance variables given the current class that is inheriting
        setup_entities if ["Intent", "Expression"].include?(@selfClass)
      end

      ## Returns the orginalHash instance variable.
      ##
      ## @return [Hash] the raw data from the call.
      def raw_data
        return @rawdata
      end

      ## Returns the REST code from the given request.
      ##
      ## @return [String] request code from the call.
      def restCode
        return @requestRest
      end

      ## Returns the request's body.
      ##
      ## @return [String] request body from the call.
      def restBody
        return @requestBody
      end

      ## Returns the request's path.
      ##
      ## @return [String] request path from the call.
      def restPath
        return @requestPath
      end


      ## Returns the list of entities from the given results. Only applicable
      ## to a few objects. If the current class is not applicable, then raise an
      ## error.
      ##
      ## @return [Array] array of entities.
      def entities
        unless ["Intent", "Expression"].include?(@selfClass)
          raise NoMethodError.new(%(The current class "#{@selfClass}' does not incorporate the '#{__method__}' method.))
        end

        ## Included so return it.
        return @entities
      end

      ## Checks if the method is one of the keys in the hash.
      ## If it is then we can return the given value.
      ## If not, then raise a NoMethodError.
      ##
      ## @params [Symbol] possible method or key in the hash
      ## @return [String] [Integer] [Hash] depending on the given results in the data.
      def method_missing(possible_key, *args, &block)
        @rawdata.has_key?(possible_key.to_s) ? @rawdata[possible_key.to_s] : super
      end

      ## Method to check if this current object is refreshable.
      ## It is refresahble if the request parameters for checking is not nil;
      ##
      ## @return [Boolean] indicating if the current object is refreshable.
      def refreshable?
        !@requestRest.nil?
      end



      private

      ## Setups entities list if the current class demands it.
      ##
      ## @return [Array] entities in this current result object.
      def setup_entities
        ## Get the current entities hash
        entities_raw = @rawdata["entities"] || @rawdata["outcome"]["entities"]
        ## Set the intance variable to be an array containing these entities.
        ## If its empty, then set the instance variable to nil
        unless entities_raw.empty?
          entities_arr = Array.new
          entities_raw.each do |entity_value|
              entities_arr << Entity.new(entity_value)
          end
          @entities = entities_arr
        else
          @entities = nil
        end
        return @entities

      end

    end

  end
end
