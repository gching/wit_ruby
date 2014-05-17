## bodyjson.rb
## Wrapper for JSON data that will be sent over to API
## TODO - better seraching for specific hash

module Wit
  module REST
    class BodyJson < OpenStruct

      ## Allows for reading for values instance variable
      attr_reader :values

      ## Mainly generates instance variable to store values.
      ##
      ## @param possible_hash [Hash] used for OpenStruct if necessary
      def initialize(possible_hash=nil)
        ## Initialize instance variable for values
        @values = Array.new
        super
      end

      ## Used to add value for an entity
      ##
      ## @param value [String] a possible value
      ## @param args [Array] posible expressions for the given value
      def add_value(value, *args)
        ## Check to see if the value already exists
        @values.each do |value_hash|
          if value_hash["value"] == value
            raise ValueAlreadyExists.new(%(The current value being inserted, "#{value}", already exists.))
          end
        end
        ## Adds it if it isn't there with the given expressions
        @values << {"value" => value,
                    "expressions" => args
                   }
      end

      ## Used to add an expression given a value.
      ##
      ## @param value [String] value that will have a new expression
      ## @param args [Array] new expressions for the value
      def add_expression(value, *args)
        ## Look for it, and insert new expressions if found.
        ## If not found, raise error
        @values.each do |value_hash|
          if value_hash["value"] == value ## Found it and insert.
            ## Set union for arrays, removes duplicates
            value_hash["expressions"] = value_hash["expressions"] | args
          else ## Not found and raise error
            raise NotFound.new(%(The value, "#{value}", cannot be found.))
          end

        end
      end

      ## Overide values to instead go into OpenStruct to work directly on the instance.
      ##
      ## @param newValues [Array] new values as an array.
      def values=(newValues)
        @values = newValues
      end


      ## Used to convert the current hash to JSON
      ##
      def json
        ## Get the current hash from OpenStruct
        current_hash = to_h
        ## add the values to it.
        current_hash["values"] = self.values
        MultiJson.dump(current_hash)

      end


    end

    class ValueAlreadyExists < Exception; end
    class NotFound < Exception; end
  end
end
