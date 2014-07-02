
require 'coveralls'
Coveralls.wear!

require 'wit_ruby'
require 'pry'

require 'webmock/rspec'
require 'vcr'
require 'timeout'

#VCR config
VCR.configure do |c|

  ## Used to see if were in the Travis CI environment.
  ## Kinda dirty as were expecting ENV["TRAVIS"] is not declared.
  ## We could use ENV["TRAVIS_WIT_TOKEN"], but that is the same dirtiness as
  ## we assume one does not have it.
  ## If it is the Travis CI environment, turn off VCR entirely and ignore cassettes.

  if ENV["TRAVIS"] == true
    puts("[WitRuby] Currently in Travis CI environment, VCR turned off.")
    VCR.turn_off!(:ignore_cassettes => true)
  else
    puts("[WitRuby] Not in Travis CI environment, VCR on and recording cassettes.")
    c.cassette_library_dir = 'spec/fixtures/wit_cassettes'
    c.hook_into :webmock
    allow_next_request_at = nil
    filters = [:real?, lambda { |r| URI(r.uri).host == 'api.wit.ai' }]

    c.after_http_request(*filters) do |request, response|
      allow_next_request_at = Time.now + 1
    end

    c.before_http_request(*filters) do |request|
      if allow_next_request_at && Time.now < allow_next_request_at
        sleep(allow_next_request_at - Time.now)
      end
    end
  end
end
