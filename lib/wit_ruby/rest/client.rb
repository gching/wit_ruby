## client.rb
## Facilitates the secure connection between the Wit servers and ruby application.
## Quite confusing as Net::HTTP and Net::HTTPs is a messy library.
## Do look it up if you need more help understanding!

module Wit
  module REST
    ## Wit::Session::Client class holds the authentication parameters and
    ## handles making the HTTP requests to the Wit API. These methods should be
    ## internally called and never called directly from the user.
    ## An example call to instantiate client is done like this with defaults:
    ##
    ## => @client = Wit::Session:Client.new
    ##
    class Client

      ## Default settings for the client connection to the Wit api.
      DEFAULTS = {
          :token => ENV["WIT_AI_TOKEN"],
          :addr => 'api.wit.ai',
          :port => 443,
          :use_ssl => true,
          :ssl_verify_peer => true,
          :ssl_ca_file => File.dirname(__FILE__) + '/../../../conf/cacert.pem',
          :timeout => 30,
          :proxy_addr => nil,
          :proxy_port => nil,
          :proxy_user => nil,
          :proxy_pass => nil,
          :retry_limit => 1,
      }

      # Allows for the reading of the last request, last response, and the
      # current session.
      attr_reader :last_request, :last_response, :session, :last_result

      ## Initialize the new instance with either the default parameters or given parameters.
      ## Token can either be given in options or defaults to ENV["WIT_AI_TOKEN"]
      ##
      ## @param options [Hash] options to overide the defaults.
      ## @return [Wit::REST::Client] new client connection.
      def initialize(options = {})
        ## Token is overidden if given in set params.
        @params = DEFAULTS.merge options
        @auth_token = @params[:token].strip
        setup_conn
        setup_session
      end


      ## Change the given auth token.
      ##
      ## @param new_auth [String] new authorization token for client.
      def change_auth(new_auth)
        @auth_token = new_auth.strip
      end

      ## Defines each REST method for the given client. GET, PUT, POST and DELETE
      ##
      ## @param path [String] path for API call.
      ## @return [Wit::REST::Result] results from the call.
      [:get, :put, :post, :delete].each do |rest_method|
        ## Get the given class for Net::HTTP depending on the current method.
        method_rest_class = Net::HTTP.const_get rest_method.to_s.capitalize

        ## Define the actual method for Wit::Session:Client
        define_method rest_method do |path, params=nil|
          request = method_rest_class.new path, {"Authorization" => "Bearer #{@auth_token}"}
          ## If post or put, set content-type to be JSON
          if [:post, :put].include?(rest_method)
            request.body = params
            request["Content-Type"] = "application/json"
            request["Accept"] = "application/vnd.wit.20160202+json"
          end
          return connect_send(request)
        end
      end

      ## Takes in a body and path and creates a net/http class and uses it to call a request to API.
      ##
      ## @param rest [String] rest code for the call.
      ## @param path [String] path for the call.
      ## @param body [Hash] body of the call.
      def request_from_result(rest, path, body)
        method_rest_class = Net::HTTP.const_get rest.capitalize
        refresh_request = method_rest_class.new path, {"Authorization" => "Bearer #{@auth_token}"}
        refresh_request.set_form_data(body) unless body == nil
        ## Connect and send it to the API server.
        return connect_send(refresh_request)
      end

#################################
      private

      ## Setup the session that allows for calling of each method.
      ##
      def setup_session
        @session = Wit::REST::Session.new(self)
      end

      ## Used to setup a connection using Net::HTTP object when making requests
      ## to the API.
      ##
      def setup_conn

        ## Setup connection through the @conn instance variable and proxy if
        ## if given.
        @conn = Net::HTTP.new(@params[:addr], @params[:port],
          @params[:proxy_addr], @params[:proxy_port],
          @params[:proxy_user], @params[:proxy_pass]
          )
        setup_ssl
        ## Set timeouts
        @conn.open_timeout = @params[:timeout]
        @conn.read_timeout = @params[:timeout]
      end

      ## Setup SSL for the given connection in @conn.
      ##
      def setup_ssl
        @conn.use_ssl = @params[:use_ssl]
        if @params[:ssl_verify_peer]
          @conn.verify_mode = OpenSSL::SSL::VERIFY_PEER
          @conn.ca_file = @params[:ssl_ca_file]
        else
          @conn.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end
      end

      ## Connect and send the given request to Wit server.
      ##
      ## @param request [Net::HTTP] specific request class from Net::HTTP library.
      ## @return [Wit::REST::Result] result from request.
      def connect_send(request)
        ## Set the last request parameter
        @last_request = request
        ## Set the retries if necessary to send again.
        left_retries = @params[:retry_limit]
        ## Start sending request
        begin
          ## Save last response and depending on the response, return back the
          ## given body as a hash.
          #binding.pry if request.method == "POST"
          response = @conn.request request
          @last_response = response
          case response.code
            when "200" then save_result_and_return(request, response)
            when "401" then raise Unauthorized, "Incorrect token or not set. Set ENV[\"WIT_AI_TOKEN\"] or pass into the options parameter as :token"
            else raise BadResponse, "response code: #{response.code} #{response.body}"
          end

        end
      end

      ## Save it into the instance last_result and return it.
      ##
      ## @param request [Net::HTTP] specific request class from Net::HTTP library.
      ## @param response [Net::HTTP] response from call to API.
      def save_result_and_return(request, response)
        ## Parse the data
        parsed_data = MultiJson.load(response.body)
        ## Save the last result as the super class Result
        @last_result = Wit::REST::Result.new(parsed_data, request.method, request.path, request.body)
        ## Return it
        return  @last_result
      end


    end

    ## Raised when response code is not 200 or 401.
    ##
    class BadResponse < Exception; end
  end
end
