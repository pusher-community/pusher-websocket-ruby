require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'bacon'

require File.dirname(__FILE__) + '/../lib/pusher-client.rb'

TEST_APP_KEY = "TEST_APP_KEY"

module PusherClient
  class TestLogger < Logger
    attr_reader :test_messages

    def initialize(logdev, shift_age = 0, shift_size = 1048576)
      @test_messages = []
      super
    end
    def test(msg)
      @test_messages << msg
      debug msg
    end
  end

  class Socket
    # Simulate a connection being established
    def connect(async = false)
      @connection_thread = Thread.new do
        @connection = TestConnection.new
        @global_channel.dispatch('pusher:connection_established', JSON.dump({'socket_id' => '123abc'}))
      end
      @connection_thread.run
      @connection_thread.join unless async
      return self
    end

    def simulate_received(event_name, event_data, channel_name)
      send_local_event(event_name, event_data, channel_name)
    end
  end

  class TestConnection
    def send(payload)
      PusherClient.logger.test("SEND: #{payload}")
    end

    def close
    end
  end

  PusherClient.logger = TestLogger.new('test.log')

end
