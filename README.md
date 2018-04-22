# pusher-client (Ruby)

[![Build Status](https://secure.travis-ci.org/pusher/pusher-websocket-ruby.svg?branch=master)](http://travis-ci.org/pusher/pusher-websocket-ruby)

`pusher-client` is a Ruby gem for consuming WebSockets from the [Pusher Channels](https://pusher.com/channels) web service.

The connection to Pusher can optionally be maintained in its own thread (see Asynchronous Usage).

This gem no longer depends on `em-http`, and is compatible with jruby since 0.2.

## Installation

```sh
gem install pusher-client
```

## Single-Threaded Usage

The application will pause at `socket.connect` and handle events from Pusher as they happen.

```ruby
require 'pusher-client'
options = { secure: true }
socket = PusherClient::Socket.new(YOUR_APPLICATION_KEY, options)

# Subscribe to two channels
socket.subscribe('channel1')
socket.subscribe('channel2')

# Subscribe to presence channel
socket.subscribe('presence-channel3', USER_ID)

# Subscribe to private channel
socket.subscribe('private-channel4', USER_ID)

# Subscribe to presence channel with custom data (user_id is mandatory)
socket.subscribe('presence-channel5', :user_id => USER_ID, :user_name => 'john')

# Bind to a global event (can occur on either channel1 or channel2)
socket.bind('globalevent') do |data|
  puts data
end

# Bind to a channel event (can only occur on channel1)
socket['channel1'].bind('channelevent') do |data|
  puts data
end

socket.connect
```

## Asynchronous Usage

The socket will remain open in the background as long as your main application thread is running,
and you can continue to subscribe/unsubscribe to channels and bind new events.

```ruby
require 'pusher-client'
socket = PusherClient::Socket.new(YOUR_APPLICATION_KEY)
socket.connect(true) # Connect asynchronously

# Subscribe to two channels
socket.subscribe('channel1')
socket.subscribe('channel2')

# Bind to a global event (can occur on either channel1 or channel2)
socket.bind('globalevent') do |data|
  puts data
end

# Bind to a channel event (can only occur on channel1)
socket['channel1'].bind('channelevent') do |data|
  puts data
end

loop do
  sleep(1) # Keep your main thread running
end
```

For further documentation, read the source & test suite. Some features of the JavaScript client
are not yet implemented.

## Native extension

Pusher depends on [the `websocket` gem](https://github.com/imanel/websocket-ruby)
which is a pure Ruby implementation of websockets.

However it can optionally use a native C or Java implementation for a 25% speed
increase by including [the `websocket-native` gem](https://github.com/imanel/websocket-ruby-native) in your Gemfile.

## Contributing to pusher-client

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright and license

See `LICENSE.txt`.
