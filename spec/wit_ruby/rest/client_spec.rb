## client_spec.rb
## Test the functionalities of lib/wit_ruby/rest/client.rb

require 'spec_helper'

describe Wit::REST::Client do
  let(:rand_auth) {"someAuth"}
  let(:another_auth)  {"someOtherAuth"}
  let(:new_host) {"api.fakewit.ai"}
  let(:new_port) {132}
  let(:new_proxy) {"localhost"}
  let(:new_proxy_port) {241}
  let(:new_timeout) {rand(30)}
  let(:new_ssl_path) {"some/ssl/path"}

  it "should create a new client instance given some auth token" do
    #pending("Need to instantiate the given client with a given token.")
    @client = Wit::REST::Client.new(token: rand_auth)
    expect(@client.instance_variable_get("@auth_token")).to  eql(rand_auth)
  end

  it "should have the proper default connection parameters" do
    @client = Wit::REST::Client.new(token: rand_auth)
    @conn = @client.instance_variable_get("@conn")
    expect(@conn.address).to  eql("api.wit.ai")
    expect(@conn.use_ssl?).to be_true

  end

  it "should allow the change of the current instance's auth token" do
    #pending("Change the instance auth token to another")
    @client = Wit::REST::Client.new(token: rand_auth)
    @client.change_auth(another_auth)
    expect(@client.instance_variable_get("@auth_token")).to eql(another_auth)
  end

  it "should allow for change of the default options and accept proxy" do
    @client = Wit::REST::Client.new(token: rand_auth, addr: new_host,
      port: new_port, ssl_ca_file: new_ssl_path, timeout: new_timeout,
      proxy_addr: new_proxy, proxy_port: new_proxy_port)
    @conn = @client.instance_variable_get("@conn")
    expect(@conn.address).to eql(new_host)
    expect(@conn.port).to eql(new_port)
    expect(@conn.proxy?).to be_true
    expect(@conn.proxy_address).to eql(new_proxy)
    expect(@conn.proxy_port).to eql(new_proxy_port)
    expect(@conn.open_timeout).to eql(new_timeout)
    expect(@conn.read_timeout).to eql(new_timeout)
    expect(@conn.ca_file).to eql(new_ssl_path)

  end

  it "should setup a session parameter to properly wrap API with commands" do
    @client = Wit::REST::Client.new(token: rand_auth)
    expect(@client.instance_variable_get("@session")).to be_true
  end
end
