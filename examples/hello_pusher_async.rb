require 'rubygems'
require 'pusher-client'
require 'pp'

YOUR_APPLICATION_KEY = ''

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
