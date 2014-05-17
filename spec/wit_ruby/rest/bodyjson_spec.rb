## bodyjson_spec.rb
## Used to test class that assists in posting / putting JSON data to API

require 'spec_helper'

describe Wit::REST::BodyJson do
  let(:id) {"some ID"}
  let(:doc) {"some documentation"}
  let(:value_1) {"some random value 1"}
  let(:value_2) {"some random value 2"}
  let(:express_1) {"some expression 1"}
  let(:express_2) {"some expression 2"}
  let(:json) {%({
    "id": "#{id}",
    "doc": "#{doc}",
    "values": [
      {
        "value": "#{value_1}",
        "expressions": ["#{express_1}"]
      },
      {
        "value": "#{value_2}",
        "expressions": ["#{express_2}"]
      }
    ]
  }
  )}
  let(:new_body) {Wit::REST::BodyJson.new}

  before do
    new_body.id = id
    new_body.doc = doc
    new_body.add_value(value_1)
    new_body.add_expression(value_1, express_1)
    new_body.add_value(value_2, express_2)
  end

  it "should have the correct values in id and doc" do
    expect(new_body.id).to eql(id)
    expect(new_body.doc).to eql(doc)
  end

  it "should have the right values and expressions" do
    expect(new_body.values).to eql([{"value" => value_1, "expressions" => [express_1]}, {"value" => value_2, "expressions" => [express_2]}])
  end

  it "should be able to generate JSON" do
    expect(new_body.json).to eql(MultiJson.dump(MultiJson.load(json)))
  end

end
