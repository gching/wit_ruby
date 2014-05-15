## result.rb
## Specifies superclass that handles the results given from each RESTful API call.


module Wit
  module REST
    class Result


      ## Instantiates with a given hash.
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
      def raw_data
        return @rawdata
      end

      ## Returns the REST code from the given request
      def restCode
        return @requestRest
      end
      ## Returns the request's body
      def restBody
        return @requestBody
      end

      ## Returns the request's path
      def restPath
        return @requestPath
      end


      ## Applicable to only a few objects
      def entities
        unless ["Intent", "Expression"].include?(@selfClass)
          raise NoMethodError.new(%(The current class "#{@selfClass}' does not incorporate the '#{__method__}' method.))
        end

        ## Included so return it
        return @entities
      end

      ## Checks if the method is one of the keys in the hash.
      ## If it is then we can return the given value.
      ## If not, then raise a NoMethodError.
      def method_missing(possible_key, *args, &block)
        @rawdata.has_key?(possible_key.to_s) ? @rawdata[possible_key.to_s] : super
      end

      ## Method to check if this current object is refreshable.
      ## It is refresahble if the request parameters for checking is not nil
      def refreshable?
        !@requestRest.nil?
      end



      private

      ## Setups entities list if the current class demands it.
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
