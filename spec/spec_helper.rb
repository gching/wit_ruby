
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
end
