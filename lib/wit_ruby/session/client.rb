module Wit
  module Session
    ## Wit::Session::Client class holds the authentication parameters and
    ## handles making the HTTP requests to the Wit API. These methods should be
    ## internally called and never called directly from the user.

    ## An example call to instantiate client is done like this:
    ##
    ## => @client = Wit::Session:Client.new auth_token
    ##
    class Client



      ## HTTP Header for API calls to Wit
      HTTP_HEADERS = {
          'Authorization' => 'Bearer #{@auth_token}'
      }
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


      ## Initialize the new instance with the given auth_token.
      def initialize(auth_token, options = {})
        @auth_token = auth_token.strip
        @params = DEFAULTS.merge! options
        setup_conn

      end


      ## Change the given auth token.
      def change_auth(new_auth)
        @auth_token = new_auth.strip
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




    end

  end
end
