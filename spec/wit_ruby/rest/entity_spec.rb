## entity_spec.rb
## Used to test functionalities of the entity wrapper for results.

require 'spec_helper'

describe Wit::REST::Entity do
  let(:json) {%({
  "builtin": true,
  "doc": "Temperature in degrees Celcius or Fahrenheit",
  "id": "temperature",
  "name": "535856ea-db8b-492b-a159-fc78cd016a4b"
  })}
  let(:rand_path) {"rand_path"}
  let(:rand_body) {"rand_body"}
  let(:rest_code) {"get"}
  let(:entity_results) {Wit::REST::Entity.new(MultiJson.load(json), rand_path, rand_body, rest_code)}

  it "should have builtin as true" do
    expect(entity_results.builtin).to eql(true)
  end

end

describe Wit::REST::MultiEntity do
  let(:json_two) {%([
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
  ])}
  let(:entity_coll) {Wit::REST::MultiEntity.new(MultiJson.load(json_two))}


  it "should be an array with entities" do
    expect(entity_coll[0].class).to eql(Wit::REST::Entity)
    expect(entity_coll[0].body).to eql("Tuesday")
  end

end

describe Wit::REST::EntityArray do
  let(:json_three) {%([
  "wit$amount_of_money",
  "wit$contact",
  "wit$datetime",
  "wit$on_off",
  "wit$phrase_to_translate",
  "wit$temperature"
  ])}
  let(:entity_array) {Wit::REST::EntityArray.new(MultiJson.load(json_three))}


  it "should be each transversable and be strings" do
    entity_array.each do |entity_sring|
      expect(entity_string.class).to eql(String)
    end
  end

end
