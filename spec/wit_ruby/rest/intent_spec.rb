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
    pending
  end

  it "should have a list of expressions" do
    pending
  end


end
