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
  let(:eql_hash) {{"doc"=> doc,
   "id" => id,
   "values"=>
    [{"value"=> value_1,
      "expressions"=>[express_1]}, {"value" => value_2, "expressions" => [express_2]}]}}
  let(:new_body) {Wit::REST::BodyJson.new}
  let(:new_body_with_value) {Wit::REST::BodyJson.new({"values" => "a"})}
  let(:new_body_with_one_value) {Wit::REST::BodyJson.new.add_value(value_1)}
  let(:new_body_with_one_expression) {new_body_with_one_value.add_expression(value_1, express_1)}

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

  it "should be able to generate a hash with no symbols" do
    expect(new_body.to_h).to eql(eql_hash)
  end

  it "should be able to remove values from the initial hash if given and be put in instance" do
    expect(new_body_with_value.instance_variable_get("@values")).to eql("a")
  end

  it "should provide a method to provide JSON for a hash rather than array for a single value" do
    expect(new_body_with_one_value.one_value_to_json).to eql("{\"value\":\"some random value 1\",\"expressions\":[]}")
  end

  it "should provide a method to provide JSON for the first expression of a given value" do
    expect(new_body_with_one_expression.one_expression_to_json(value_1)).to eql(%({"expression":"#{express_1}"}))
  end

end
