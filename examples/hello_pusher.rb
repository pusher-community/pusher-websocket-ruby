require 'rubygems'
require './lib/pusher-client.rb'
require 'pp'

YOUR_APPLICATION_KEY = ''

PusherClient.logger = Logger.new('/dev/null')
socket = PusherClient::Socket.new(YOUR_APPLICATION_KEY)

# Subscribe to a channel
socket.subscribe('hellopusher')

# Bind to a channel event
socket['hellopusher'].bind('hello') do |data|
  pp data
end

socket.connect
