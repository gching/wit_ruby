## intent_spec.rb
## Used to test functionalities of intent wrapper in wit_ruby/rest/intent.rb

require 'spec_helper'

describe Wit::REST::Intent do
  let(:json) {%({
  "expressions" : [ {
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
  }, {
    "id" : "-2385b07e09b74a-d95db384-fac2-4e41-85ca-3072778aa99c",
    "body" : "i wanna fly from JFK to SFO",
    "entities" : [ {
      "wisp" : "wit$location",
      "start" : 24,
      "end" : 27,
      "role" : "dest",
      "body" : "SFO",
      "value" : "SFO"
    }, {
      "wisp" : "wit$location",
      "start" : 17,
      "end" : 20,
      "role" : "orig",
      "body" : "JFK ",
      "value" : "JFK"
    } ]
  } ],
  "entities" : [ {
    "role" : "dest",
    "id" : "wit$location"
  }, {
    "role" : "orig",
    "id" : "wit$location"
  } ],
  "id" : "52bab83b-fbef-40db-b19d-a0dccd38cfdc",
  "name" : "book_flight",
  "doc" : "book flight"
  })}
  let(:rand_path) {"rand_path"}
  let(:rand_body) {"rand_body"}
  let(:rest_code) {"get"}
  let(:intent_results) {Wit::REST::Intent.new(MultiJson.load(json), rand_path, rand_body, rest_code)}


  it "should have a list of entities" do
    expect(intent_results.entities.class).to eql(Array)
    expect(intent_results.entities[0].class).to eql(Wit::REST::Entity)
  end
  it "should have a list of expressions" do
    expect(intent_results.expressions.class).to eql(Array)
    expect(intent_results.expressions[0].class).to eql(Wit::REST::Expression)
  end

  it "should have the right values in the entities" do
    expect(intent_results.entities[0].role).to eql("dest")
    expect(intent_results.entities[1].role).to eql("orig")
  end

  it "should have the right values for expressions" do
    expect(intent_results.expressions[0].body).to eql("fly from incheon to sfo")
    expect(intent_results.expressions[1].body).to eql("i wanna fly from JFK to SFO")
  end
  it "should return the body names for each expressions as an array of strings" do
    expect(intent_results.expression_bodies).to eql(["fly from incheon to sfo", "i wanna fly from JFK to SFO"])
  end
  it "should return used entities as an array of strings" do
    expect(intent_results.entities_used).to eql(["wit$location"])
  end


end

describe Wit::REST::MultiIntent do
  let(:json_two) {%([ {
  "id" : "52bab833-e024-4f15-b927-8e0772d1540c",
  "name" : "recover_password",
  "doc" : "Recover password (which is different from Reset password).",
  "metadata" : "password_23433253254"
  }, {
  "id" : "52bab833-9a1e-4bff-b659-99ee95e6c1f9",
  "name" : "transfer",
  "doc" : "Transfer some amount of money between two accounts."
  }, {
  "id" : "52bab833-3e23-4c67-9cfc-a0fed605bd77",
  "name" : "show_movie",
  "doc" : "Show a given movie."
  } ])}
  let(:rand_path) {"rand_path"}
  let(:rand_body) {"rand_body"}
  let(:rest_code) {"get"}
  let(:multi_intent_results) {Wit::REST::MultiIntent.new(MultiJson.load(json_two), rand_path, rand_body, rest_code)}

  it "should each be saved as a result object" do
    multi_intent_results.each do |intent|
      expect(intent.class).to eql Result
    end
  end

end
