# Fire and Forget HTTP client

Using this gem is probably a very bad idea in at least 98% of the cases
I can think of. Think of a it as a HTTP client that doesn't care about
the response and doesn't care about basically anything besides sending
its payload to a server. An alternative name for this client is
"scumbag-HTTP-client".

So, unless you are really sure you want to use this lib, you're probably
better off looking at the hundreds other Ruby HTTP libraries.

## Installation

Add this line to your application's Gemfile:

    gem 'fire-and-forget', :require => 'fire/forget'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fire-and-forget

## Usage

```ruby
FAF.post "http://example.com", {:foo => 'bar'}, {"X-Custom" => true}
```

Currently, FAF only supports very basic options, no
authentication unless you pass all the details via the headers.

Once the request is sent, the socket is closed which might or might not
please the server receiving the request.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
