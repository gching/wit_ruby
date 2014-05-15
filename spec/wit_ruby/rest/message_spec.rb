## message_spec.rb
## Used to test wrapper for message results


require 'spec_helper'

describe Wit::REST::Message do
  let(:json) {%({
  "msg_id": "ba0fcf60-44d3-4499-877e-c8d65c239730",
  "msg_body": "how many people between Tuesday and Friday",
  "outcome": {
    "intent": "query_metrics",
    "entities": {
      "metric": {
        "value": "metric_visitors",
        "body": "people",
        "metadata": "{'code' : 324}"
      },
      "datetime": [
        {
          "value": {
            "from": "2013-10-21T00:00:00.000Z",
            "to": "2013-10-22T00:00:00.000Z"
          },
          "body": "Tuesday"
        },
        {
          "value": {
            "from": "2013-10-24T00:00:00.000Z",
            "to": "2013-10-25T00:00:00.000Z"
          },
          "body": "Friday"
        }
      ]
    },
    "confidence": 0.979
  }
  })}
  let(:rand_path) {"rand_path"}
  let(:rand_body) {"rand_body"}
  let(:rest_code) {"get"}
  let(:message_results) {Wit::REST::Message.new(MultiJson.load(json), rand_path, rand_body, rest_code)}


  it "should have the following parameters, confidence and intent and entities" do
    expect(message_results.confidence).to eql(0.979)
    expect(message_results.intent).to eql("query_metrics")
    expect(message_results.metric.class).to eql(Wit::REST::Entity)
    expect(message_results.datetime.class).to eql(Wit::REST::MultiEntity)
  end

  it "should have the right values in the entities" do
    expect(message_results.metric.value).to eql("metric_visitors")
    expect(message_results.datetime[0].body).to eql("Tuesday")
  end

  it "should be able to return back an array of strings of the names of each entity" do
    expect(message_results.entity_names).to eql(["metric", "datetime"])
  end



end
