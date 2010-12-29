require 'json'
require 'eventmachine'
require 'em-http'

module PusherClient
  class Socket
    
    # Mimick the JavaScript client
    CLIENT_ID = 'js' 
    VERSION = '1.7.1'

    attr_accessor :encrypted, :secure
    attr_reader :path, :connected, :channels, :global_channel, :socket_id

    def initialize(application_key, options={})

      @path = "/app/#{application_key}?client=#{CLIENT_ID}&version=#{VERSION}"
      @key = application_key
      @socket_id = nil
      @channels = Channels.new
      @global_channel = Channel.new('pusher_global_channel')
      @global_channel.global = true
      @secure = false
      @connected = false
      @encrypted = options[:encrypted] || false

      bind('pusher:connection_established') do |data|
        @connected = true
        @socket_id = data['socket_id']
        subscribe_all
      end

      bind('pusher:connection_disconnected') do |data|
        @channels.channels.each { |c| c.disconnect }
      end

      bind('pusher:error') do |data|
        PusherClient.logger.fatal("Pusher : error : #{data.message}")
      end
    end

    def connect(async = false)
      @connection_thread = Thread.new do
        EventMachine.run {
          if @encrypted || @secure
            url = "wss://#{HOST}:#{WSS_PORT}#{@path}"
          else
            url = "ws://#{HOST}:#{WS_PORT}#{@path}"
          end
          PusherClient.logger.debug("Pusher : connecting : #{url}")

          @connection = EventMachine::HttpRequest.new(url).get :timeout => 0

          @connection.callback {
            PusherClient.logger.debug "Websocket connected"
          }

          @connection.stream { |msg|
            PusherClient.logger.debug "Received: #{msg}"
            params  = parser(msg)
            return if (params['socket_id'] && params['socket_id'] == this.socket_id)

            event_name   = params['event']
            event_data   = params['data']
            channel_name = params['channel']

            send_local_event(event_name, event_data, channel_name)
          }

          @connection.errback {
            PusherClient.logger.fatal "Pusher : eventmachine error"
          }

          @connection.disconnect {
            PusherClient.logger.debug "Pusher : dropped connection"
          }
        }
      end
      @connection_thread.run
      if async
        sleep(1)
      else
        @connection_thread.join
      end
      return self
    end

    def disconnect
      if @connected
        PusherClient.logger.debug "Pusher : disconnecting"
        @connection_thread.kill if @connection_thread
        @connected = false
      else
        PusherClient.logger.warn "Disconnect attempted... not connected"
      end
    end

    def subscribe(channel_name)
      channel = @channels << channel_name
      if @connected
        send_event('pusher:subscribe', {
          'channel' => channel_name
        })
        channel.acknowledge_subscription(nil)
      end
      return channel
    end

    def unsubscribe(channel_name)
      channel = @channels.remove channel_name
      if @connected
        send_event('pusher:unsubscribe', {
          'channel' => channel_name
        })
      end
      return channel
    end

    def bind(event_name, &callback)
      @global_channel.bind(event_name, &callback)
      return self
    end

    def [](channel_name)
      if @channels[channel_name]
        @channels[channel_name]
      else
        @channels << channel_name
      end
    end

    def subscribe_all
      @channels.channels.each_with_index { |k,v| subscribe(k) }
    end
    
    # For compatibility with JavaScript client API
    alias :subscribeAll :subscribe_all 

    def send_event(event_name, data)
      payload = {'event' => event_name, 'data' => data}.to_json
      @connection.send(payload)
      PusherClient.logger.debug("Pusher : sending event : #{payload}")
    end

  protected

    def send_local_event(event_name, event_data, channel_name)
      if (channel_name)
        channel = @channels[channel_name]
        if (channel)
          channel.dispatch_with_all(event_name, event_data)
        end
      end

      @global_channel.dispatch_with_all(event_name, event_data)
      PusherClient.logger.debug("Pusher : event received : channel: #{channel_name}; event: #{event_name}")
    end

    def parser(data)
      begin
        return JSON.parse(data)
      rescue => err
        PusherClient.logger.warn(err)
        PusherClient.logger.warn("Pusher : data attribute not valid JSON - you may wish to implement your own Pusher::Client.parser")
        return data
      end
    end
  end

end
