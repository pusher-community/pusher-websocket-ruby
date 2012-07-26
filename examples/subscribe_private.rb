# Usage: $ PUSHER_KEY=YOURKEY ruby examples/hello_pusher.rb

require 'rubygems'
require './lib/pusher-client.rb'
require 'pp'

APP_KEY = ENV['PUSHER_KEY'] # || "YOUR_APPLICATION_KEY"
APP_SECRET = ENV['PUSHER_SECRET'] # || "YOUR_APPLICATION_SECRET"

PusherClient.logger = Logger.new(STDOUT)
socket = PusherClient::Socket.new(APP_KEY, { :encrypted => true, :secret => APP_SECRET } )

# Subscribe to a channel
socket.subscribe('private-hellopusher')

# Bind to a channel event
socket['hellopusher'].bind('hello') do |data|
  pp data
end

socket.connect
