# pusher-client: Ruby WebSocket client for Pusher Channels

[![Build Status](https://secure.travis-ci.org/pusher/pusher-websocket-ruby.svg?branch=master)](http://travis-ci.org/pusher/pusher-websocket-ruby)

`pusher-client` is a Ruby gem for consuming WebSockets from the [Pusher Channels](https://pusher.com/channels) web service.

## Installation

```sh
gem install pusher-client
```

This gem is compatible with jruby since 0.2.

## Single-Threaded Usage

The application will pause at `channels_client.connect` and handle events from Pusher Channels as they happen.

```ruby
require 'pusher-client'
cluster = 'mt1'  # take this from your app's config in the dashboard
channels_client = PusherClient::Socket.new(YOUR_APPLICATION_KEY, {
  secure: true,
  ws_host: "ws-#{cluster}.pusher.com"
})

# Subscribe to two channels
channels_client.subscribe('channel1')
channels_client.subscribe('channel2')

# Subscribe to presence channel
channels_client.subscribe('presence-channel3', USER_ID)

# Subscribe to private channel
channels_client.subscribe('private-channel4', USER_ID)

# Subscribe to presence channel with custom data (user_id is mandatory)
channels_client.subscribe('presence-channel5', :user_id => USER_ID, :user_name => 'john')

# Bind to a global event (can occur on either channel1 or channel2)
channels_client.bind('globalevent') do |data|
  puts data
end

# Bind to a channel event (can only occur on channel1)
channels_client['channel1'].bind('channelevent') do |data|
  puts data
end

channels_client.connect
```

## Asynchronous Usage

With `channels_client.connect(true)`,
the connection to Pusher Channels will be maintained in its own thread.
The connection will remain open in the background as long as your main application thread is running,
and you can continue to subscribe/unsubscribe to channels and bind new events.

```ruby
require 'pusher-client'
channels_client = PusherClient::Socket.new(YOUR_APPLICATION_KEY)
channels_client.connect(true) # Connect asynchronously

# Subscribe to two channels
channels_client.subscribe('channel1')
channels_client.subscribe('channel2')

# Bind to a global event (can occur on either channel1 or channel2)
channels_client.bind('globalevent') do |data|
  puts data
end

# Bind to a channel event (can only occur on channel1)
channels_client['channel1'].bind('channelevent') do |data|
  puts data
end

loop do
  sleep(1) # Keep your main thread running
end
```

## Using native WebSocket implementation

This gem depends on [the `websocket` gem](https://github.com/imanel/websocket-ruby)
which is a pure Ruby implementation of websockets.

However it can optionally use a native C or Java implementation for a 25% speed
increase by including [the `websocket-native` gem](https://github.com/imanel/websocket-ruby-native) in your Gemfile.

## Copyright and license

See `LICENSE.txt`.
