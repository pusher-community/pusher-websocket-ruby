require 'rubygems'
require './lib/pusher-client.rb'
require 'pp'

YOUR_APPLICATION_KEY = '73c70db2f09b7f279382'

PusherClient.logger = Logger.new('/dev/null')
socket = PusherClient::Socket.new(YOUR_APPLICATION_KEY)
socket.connect(true)

# Subscribe to a channel
socket.subscribe('hellopusher')

# Bind to a channel event
socket['hellopusher'].bind('hello') do |data|
  pp data
end

loop do
  sleep 1
end
