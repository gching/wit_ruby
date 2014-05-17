

# WitRuby

Provides a unofficial Ruby API Wrapper for the Wit.ai API. Still implementing most functionalities. Go over to https://rubygems.org/gems/wit_ruby for specific information and documentation.

[![Build Status](https://travis-ci.org/gching/wit_ruby.svg?branch=master)](https://travis-ci.org/gching/wit_ruby)
[![Gem Version](https://badge.fury.io/rb/wit_ruby.png)](http://badge.fury.io/rb/wit_ruby)
[![Coverage Status](https://coveralls.io/repos/gching/wit_ruby/badge.png?branch=master)](https://coveralls.io/r/gching/wit_ruby?branch=master)

## Installation

Add this line to your application's Gemfile:

    gem 'wit_ruby'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install wit_ruby

## Usage

Remember to put this up to access it!

    $ require 'wit_ruby'

To start using the wrapper, create a client with an authorization token given from Wit.ai. Set this either in ENV["WIT_AI_TOKEN"] or pass it on it the parameters as a hash. Default settings can be overridden by this hash as well.

    $ ## Default to ENV["WIT_AI_TOKEN"]
    $ client = Wit::REST::Client.new()
    $ ## Override token when created
    $ client = Wit::REST::Client.new(token: "Insert Token Here")

The client provides also a session for you to mainly do API calls. I suggest you save the session somewhere for easy access.

    $ session = client.session

As of 0.0.2, only sending a message, getting message information and intent specific calls are implemented.

## Message

To send a specific message, use the saved session to send a given string as a parameter.

    $ results = session.send_message("Your Message")

To get a specific messages information from the wit.ai, pass in the message's ID and use the method below.

    $ results = session.get_message("Message ID")

## Intent

To get a list of intents in the specific instance over at wit.ai.

    $ ## Array of all intents used.
    $ results = session.get_intents

To get a specific intent information, pass in it's ID or name.

    $ ## Specific intent information.
    $ results = session.get_intents("Intent ID or Name")

## Result

Every method returns a class wrapper corresponding specifically to that result. The superclass that is inherited (Wit::REST::Result) allows for you to easily access the results of the API call. The results is converted to a hash and is saved in this result class.
You can call methods on it and if it matches the result's hash, it will return it's value. For example,

    $ ## results.hash = {"a" => "b"}
    $ results.a
    $  => "b"

## Contributing

I am a beginner developer so do contribute or help as much as possible! I definitely need to learn a lot :).

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Licensing
Copyright (c) 2014 Gavin Ching

MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
