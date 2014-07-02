## message_spec.rb
## Used to test wrapper for message results


require 'spec_helper'

describe Wit::REST::Message do
  let(:json) {%(

  {
    "msg_id" : "c20ad081-2cb9-4c63-8dd6-6667409514fa",
    "outcomes" : [ {
      "_text" : "how many people between Tuesday and Friday",
      "intent" : "query_metrics",
      "entities" : {
        "metric" : [ {
          "metadata" : "{'code' : 324}",
          "value" : "metric_visitor"
        } ],
        "datetime" : [ {
          "value" : {
            "from" : "2014-06-24T00:00:00.000+02:00",
            "to" : "2014-06-25T00:00:00.000+02:00"
          }
        }, {
          "value" : {
            "from" : "2014-06-27T00:00:00.000+02:00",
            "to" : "2014-06-28T00:00:00.000+02:00"
          }
        } ]
      },
      "confidence" : 0.986
    } ]
  }

  )}
  let(:rand_path) {"rand_path"}
  let(:rand_body) {"rand_body"}
  let(:rest_code) {"get"}
  let(:message_results) {Wit::REST::Message.new(MultiJson.load(json), rand_path, rand_body, rest_code)}


  it "should have the following parameters, confidence and intent and entities" do
    expect(message_results.confidence).to eql(0.986)
    expect(message_results.intent).to eql("query_metrics")
    expect(message_results.metric.class).to eql(Wit::REST::EntityArray)
    expect(message_results.datetime.class).to eql(Wit::REST::EntityArray)
  end

  it "should have the right values in the entities" do
    expect(message_results.metric[0].value).to eql("metric_visitor")
    expect(message_results.datetime[0].value["from"]).to eql("2014-06-24T00:00:00.000+02:00")
  end

  it "should be able to return back an array of strings of the names of each entity" do
    expect(message_results.entity_names).to eql(["metric", "datetime"])
  end



end
