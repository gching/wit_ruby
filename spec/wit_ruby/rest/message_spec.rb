## message_spec.rb
## Used to test wrapper for message results


require 'spec_helper'

describe Wit::REST::Message do
  let(:json) {%({
    "msg_id" : "aa296547-3617-4e97-95f5-a71b5093c2ba",
    "msg_body" : "Hi",
    "outcome" : {
      "intent" : "greetings",
      "entities" : { },
      "confidence" : 0.26
    }
  })}
  let(:rand_path) {"rand_path"}
  let(:rand_body) {"rand_body"}
  let(:rest_code) {"get"}
  let(:message_results) {Wit::REST::Message.new(MultiJson.load(json), rand_path, rand_body, rest_code)}

  it "should inherit from Wit::REST::Result" do
    pending
  end

  it "should have the following parameters, confidence and intent" do
    expect(message_results.confidence).to eql(0.26)
    expect(message_results.intent).to eql("greetings")
  end

  it "should have a list of entities" do
    pending
  end



end
