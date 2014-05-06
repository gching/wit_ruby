module Wit
  module REST
    ## Wit::Session::Client class holds the authentication parameters and
    ## handles making the HTTP requests to the Wit API. These methods should be
    ## internally called and never called directly from the user.

    ## An example call to instantiate client is done like this:
    ##
    ## => @client = Wit::Session:Client.new auth_token
    ##
    class Client


      ## HTTP Header for API calls to Wit
    #  HTTP_HEADERS = {
      #    "Authorization" => "Bearer #{@auth_token}"
    #  }
      DEFAULTS = {
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

      attr_reader :last_req, :last_response, :session

      ## Initialize the new instance with the given auth_token.
      def initialize(auth_token, options = {})
        @auth_token = auth_token.strip
        @params = DEFAULTS.merge options
        setup_conn
        setup_session
      end


      ## Change the given auth token.
      def change_auth(new_auth)
        @auth_token = new_auth.strip
      end

      ## Defines each REST method for the given client. GET, PUT, POST and DELETE
      [:get, :put, :post, :delete].each do |rest_method|
        ## Get the given class for Net::HTTP depending on the current method.
        method_rest_class = Net::HTTP.const_get rest_method.to_s.capitalize

        ## Define the actual method for Wit::Session:Client
        define_method rest_method do |path|#|path, params|
        #  params = twilify args[0]; params = {} if params.empty?
        #  unless args[1] # build the full path unless already given
        #    path = "#{path}.json"
        #    path << "?#{url_encode(params)}" if rest_method == :get && !params.empty?
        #  end
          request = method_rest_class.new path, {"Authorization" => "Bearer #{@auth_token}"}
        # request.basic_auth @account_sid, @auth_token
          #request.set_form_data(params)#params if [:post, :put].include?(rest_method)

          return connect_send(request)
        end
      end

#################################
      private

      ## Used to setup a connection using Net::HTTP object when making requests
      ## to the API.
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
      def setup_ssl
        @conn.use_ssl = @params[:use_ssl]
        if @params[:ssl_verify_peer]
          @conn.verify_mode = OpenSSL::SSL::VERIFY_PEER
          @conn.ca_file = @params[:ssl_ca_file]
        else
          @conn.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end
      end

      def connect_send(request)
        @last_req = request
        left_retries = @params[:retry_limit]
        ## Start sending request
        begin
          response = @conn.request request
          @last_response = response
          #binding.pry
          #if response.code == "200"
          #  binding.pry
        #end
          case response.code
            when "200" then MultiJson.load response.body
            when "401" then raise Unauthorized, "incorrect token set for Wit.token set an env for WIT_TOKEN or set Wit::TOKEN manually"
            #else raise BadResponse, "response code: #{response.status}"
          end

        end
      end

      def setup_session
        @session = Wit::REST::Session.new(self)
      end
    end
  end
end
