## result_spec.rb
## Tests functionalities of lib/wit_ruby/rest/result.rb
require 'spec_helper'

describe Wit::REST::Result do
  let(:randHash) {{"a" => "a", "b" => "b"}}
  let(:result) {Wit::REST::Result.new(randHash)}

  it "should have an intance of the original hash" do
    expect(result.instance_variable_get("@originalHash")).to eql(randHash)
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
end
