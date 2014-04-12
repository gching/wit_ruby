require 'spec_helper'

describe Wit::Session::Client do
  before do
    @rand_auth = "someAuth"
    @another_auth = "someOtherAuth"
    @new_host = "api.fakewit.ai"
    @new_port = 132
    @new_proxy= "localhost"
    @new_proxy_port = 241
    @new_timeout = rand(30)
    @new_ssl_path = "some/ssl/path"
  end

  it "should create a new client instance given some auth token" do
    #pending("Need to instantiate the given client with a given token.")
    @client = Wit::Session::Client.new (@rand_auth)
    expect(@client.instance_variable_get("@auth_token")).to  eql(@rand_auth)
  end

  it "should have the proper default connection parameters" do
    @client = Wit::Session::Client.new(@rand_auth)
    @conn = @client.instance_variable_get("@conn")
    expect(@conn.address).to  eql("api.wit.ai")
    expect(@conn.port).to eql(443)
    expect(@conn.use_ssl?).to be_true

  end

  it "should allow the change of the current instance's auth token" do
    #pending("Change the instance auth token to another")
    @client = Wit::Session::Client.new(@rand_auth)
    @client.change_auth(@another_auth)
    expect(@client.instance_variable_get("@auth_token")).to eql(@another_auth)
  end

  it "should allow for change of the default options and accept proxy" do
    @client = Wit::Session::Client.new(@rand_auth, addr: @new_host,
      port: @new_port, ssl_ca_file: @new_ssl_path, timeout: @new_timeout,
      proxy_addr: @new_proxy, proxy_port: @new_proxy_port)
    @conn = @client.instance_variable_get("@conn")
    expect(@conn.address).to eql(@new_host)
    expect(@conn.port).to eql(@new_port)
    expect(@conn.proxy?).to be_true
    expect(@conn.proxy_address).to eql(@new_proxy)
    expect(@conn.proxy_port).to eql(@new_proxy_port)
    expect(@conn.open_timeout).to eql(@new_timeout)
    expect(@conn.read_timeout).to eql(@new_timeout)
    expect(@conn.ca_file).to eql(@new_ssl_path)

  end
end
