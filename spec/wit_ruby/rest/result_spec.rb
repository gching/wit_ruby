## result_spec.rb
## Tests functionalities of lib/wit_ruby/rest/result.rb
require 'spec_helper'

describe Wit::REST::Result do
  let(:randHash) {{"a" => "a", "b" => "b"}}
  let(:rand_path) {"rand_path"}
  let(:rand_body) {"rand_body"}
  let(:rest_code) {"post"}
  let(:result) {Wit::REST::Result.new(randHash, rest_code, rand_path, rand_body)}
  let(:not_refresh_result) {Wit::REST::Result.new(randHash)}

  it "should have an instance of the original hash" do
    expect(result.raw_data).to eql(randHash)
  end

  it "should raise an error for a method that is not in the attributes of the hash" do
    expect{result.random_method}.to raise_error(NoMethodError)
  end

  it ".method_missing(name, *args, &block" do
    expect(result).to respond_to(:method_missing)
  end

  it "should not raise any errors for the given keys in a hash" do
    randHash.each_key do |key|
      expect{result.send(key)}.not_to raise_error
    end
  end


  it "should have an optional parameters to store the original request's body and pth" do
    expect(result.restCode).to eql(rest_code)
    expect(result.restPath).to eql(rand_path)
    expect(result.restBody).to eql(rand_body)
  end

  it "should be refereshable if rest parameters and path/body are given and not if it isn't given" do
    expect(result.refreshable?).to be_true
    expect(not_refresh_result.refreshable?).to be_false
  end

end
