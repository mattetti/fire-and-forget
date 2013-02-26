# Fire and Forget HTTP client

You probably don't need this gem. 
Think of a it as a HTTP client that doesn't care about
the response once it sent its request and doesn't care about basically anything besides sending
its payload to a server and making sure the connection was established.

So, unless you are really sure you want to use this lib, you're probably
better off looking at the many other Ruby HTTP libraries out there.

## Installation

Add this line to your application's Gemfile:

    gem 'fire-and-forget', :require => 'fire/forget'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fire-and-forget

## Usage

```ruby
FAF.post "http://example.com", {:foo => 'bar'}, {"X-Header" => true}
```
In the example above, the request will be sent as a JSON request and the
body (a Ruby hash) will be converted to json if `to_json` is available on
the object (otherwise `to_s` will be used).

```ruby
FAF.post "http://example.com", "{\"language\": {\"created_at\": \"2010/11/23 19:47:05 +0000\",\"updated_at\": \"2010/11/23 19:47:05 +0000\",\"active\": true, \"code\": \"en\", \"id\":37}}"
```

Would send the request passing the JSON string as the body, strings
aren't converted when passed as the request body.

Sometimes, you might want to debug the response or potentially slow down
the application code. You can pass a block to do that:

```ruby
FAF.post "http://example.com", {:foo => 'bar'} do
  sleep(0.02) # sleep 20ms before closing the socket
end
```

or 

```ruby
FAF.post "http://example.com", {:foo => 'bar'} do |socket|
  while output = socket.gets
    print output
  end
end
```

Note that the block is executed before the connection is closed which is
important if you want the client to wait before closing the socket, or
if you want to read.

This approach wont "forget" about the response, but instead wait for data to
come down the socket so we can print it.

If you are interested in waiting for a minimum of x ms but stop waiting
as soon as something comes back from the socket, you can use
`select`:

```ruby
FAF.get "http://github.com/mattetti" do |socket|
  IO.select([socket], nil, nil, 0.02)
end
```

The code above would make a request and will wait for a response from
the socket or will close the socket after 20ms. It's a nice way to set a
max waiting response time on your client.


Currently, FAF only supports basic options, no
authentication unless you pass all the details via the headers.

Once the request is sent, the socket is closed which might or might not
please the server receiving the request (you might want to use a
block/sleep
to slow down the closing of the socket if your proxy/cache doesn't like
that FAF closes the connection right away.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
