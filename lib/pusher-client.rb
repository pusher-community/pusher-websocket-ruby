autoload :Logger, 'logger'

module PusherClient
  @host = 'ws.pusherapp.com'
  @ws_port = 8080
  @wss_port = 443

  @logger = Logger.new(STDOUT)

  class << self
    attr_accessor :logger, :host, :ws_port, :wss_port
  end
end


Thread.abort_on_exception = true

require File.dirname(__FILE__) + '/pusher-client/websocket.rb'
require File.dirname(__FILE__) + '/pusher-client/socket.rb'
require File.dirname(__FILE__) + '/pusher-client/channel.rb'
require File.dirname(__FILE__) + '/pusher-client/channels.rb'
