autoload :Logger, 'logger'

module PusherClient
  HOST = 'ws.pusherapp.com'
  WS_PORT = 80
  WSS_PORT = 443

  @logger = Logger.new(STDOUT)

  def self.logger
    @logger
  end

  def self.logger=(logger)
    @logger = logger
  end
end

Thread.abort_on_exception = true

require 'pusher-client/version'
require 'pusher-client/websocket'
require 'pusher-client/socket'
require 'pusher-client/channel'
require 'pusher-client/channels'
