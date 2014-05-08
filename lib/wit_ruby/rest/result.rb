## result.rb
## Specifies class that handles the results given from each RESTful API call.


module Wit
  module REST
    class Result


    ## Instantiates with a given hash.
    def initialize(resultHash, requestRest=nil, requestPath=nil, requestBody=nil)
      @originalHash = resultHash
      @requestRest = requestRest
      @requestPath = requestPath
      @requestBody = requestBody
    end

    ## Returns the orginalHash instance variable.
    def hash
      return @originalHash
    end

    ## Returns the REST code from the given request
    def restCode
      return @requestRest
    end
    ## Returns the request's body
    def body
      return @requestBody
    end

    ## Returns the request's path
    def path
      return @requestPath
    end


    ## Checks if the method is one of the keys in the hash.
    ## If it is then we can return the given value.
    ## If not, then raise a NoMethodError.
    def method_missing(possible_key, *args, &block)
      @originalHash.has_key?(possible_key.to_s) ? @originalHash[possible_key.to_s] : super
    end



    end
  end
end
