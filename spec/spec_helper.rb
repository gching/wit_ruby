
require 'coveralls'
Coveralls.wear!

require 'wit_ruby'
require 'pry'

require 'webmock/rspec'
require 'vcr'
require 'timeout'

#VCR config
VCR.configure do |c|
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
