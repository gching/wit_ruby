## expression_spec.rb
## Used to test functionalities of internal result wrappers for expressions.
require 'spec_helper'

describe Wit::REST::Expression do
  let(:json) {%(
  {
    "id" : "-2385b07a3900bd-8393b722-6d4e-4185-bb18-410136cdb794",
    "body" : "fly from incheon to sfo",
    "entities" : [ {
      "wisp" : "wit$location",
      "start" : 20,
      "end" : 23,
      "role" : "dest",
      "body" : "sfo",
      "value" : "sfo"
    }, {
      "wisp" : "wit$location",
      "start" : 9,
      "end" : 16,
      "role" : "orig",
      "body" : "incheon ",
      "value" : "incheon"
    } ]
  })}
  let(:express_results) {Wit::REST::Expression.new(MultiJson.load(json))}

  it "should have a list of entities" do
    expect(express_results.entities.class).to eql(Array)
    expect(express_results.entities[0].class).to eql(Wit::REST::Entity)
  end

  it "should have the correct indexes and values" do
    expect(express_results.entities[0].start).to eql(20)
    expect(express_results.entities[1].start).to eql(9)
  end

end
