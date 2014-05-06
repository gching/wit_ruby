## result.rb
## Specifies class that handles the results given from each RESTful API call.


module Wit
  module REST
    class Result

    ## Instantiates with a given hash.
    def initialize(resultHash)
      @originalHash = resultHash
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
