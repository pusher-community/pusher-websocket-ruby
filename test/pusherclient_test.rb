require File.dirname(File.expand_path(__FILE__)) + '/teststrap.rb'
require 'logger'

describe "A PusherClient::Channels collection" do
  before do
    @channels = PusherClient::Channels.new
  end

  it "should initialize empty" do
    @channels.empty?.should.equal(true)
    @channels.size.should.equal 0
  end

  it "should instantiate new channels added to it by name" do
    @channels << 'TestChannel'
    @channels.find('TestChannel').class.should.equal(PusherClient::Channel)
  end

  it "should allow removal of channels by name" do
    @channels << 'TestChannel'
    @channels['TestChannel'].class.should.equal(PusherClient::Channel)
    @channels.remove('TestChannel')
    @channels.empty?.should.equal(true)
  end

  it "should not allow two channels of the same name" do
    @channels << 'TestChannel'
    @channels << 'TestChannel'
    @channels.size.should.equal 1
  end

end

describe "A PusherClient::Channel" do
  before do
    @channels = PusherClient::Channels.new
    @channel = @channels << "TestChannel"
  end

  it 'should not be subscribed by default' do
    @channel.subscribed.should.equal false
  end

  it 'should not be global by default' do
    @channel.global.should.equal false
  end

  it 'can have procs bound to an event' do
    @channel.bind('TestEvent') {}
    @channel.callbacks.size.should.equal 1
  end

  it 'should run callbacks when an event is dispatched' do

    @channel.bind('TestEvent') do
      PusherClient.logger.test "Local callback running"
    end

    @channel.dispatch('TestEvent', {})
    PusherClient.logger.test_messages.should.include?("Local callback running")
  end

end

describe "A PusherClient::Socket" do
  before do
    @socket = PusherClient::Socket.new(TEST_APP_KEY, :secret => 'secret')
  end

  it 'should not connect when instantiated' do
    @socket.connected.should.equal false
  end

  it 'should raise ArgumentError if TEST_APP_KEY is not a nonempty string' do
    lambda { 
      @broken_socket = PusherClient::Socket.new('')
    }.should.raise(ArgumentError)
    lambda { 
      @broken_socket = PusherClient::Socket.new(555)
    }.should.raise(ArgumentError)
  end

  describe "...when connected" do
    before do
      @socket.connect
    end

    it 'should know its connected' do
      @socket.connected.should.equal true
    end

    it 'should know its socket_id' do
      @socket.socket_id.should.equal '123abc'
    end

    it 'should not be subscribed to its global channel' do
      @socket.global_channel.subscribed.should.equal false
    end

    it 'should subscribe to a channel' do
      @channel = @socket.subscribe('testchannel')
      @socket.channels['testchannel'].should.equal @channel
      @channel.subscribed.should.equal true
    end

    it 'should unsubscribe from a channel' do
      @channel = @socket.unsubscribe('testchannel')
      PusherClient.logger.test_messages.last.should.include?('pusher:unsubscribe')
      @socket.channels['testchannel'].should.equal nil
    end

    it 'should subscribe to a private channel' do
      @channel = @socket.subscribe('private-testchannel')
      @socket.channels['private-testchannel'].should.equal @channel
      @channel.subscribed.should.equal true
    end

    it 'should subscribe to a presence channel with user_id' do
      @channel = @socket.subscribe('presence-testchannel', '123')
      @socket.channels['presence-testchannel'].should.equal @channel
      @socket.instance_variable_get('@user_data').should.equal '{"user_id":"123"}'
      @channel.subscribed.should.equal true
    end

    it 'should subscribe to a presence channel with custom channel_data' do
      @channel = @socket.subscribe('presence-testchannel', :user_id => '123', :user_name => 'john')
      @socket.channels['presence-testchannel'].should.equal @channel
      @socket.instance_variable_get('@user_data').should.equal '{"user_id":"123","user_name":"john"}'
      @channel.subscribed.should.equal true
    end

    it 'should allow binding of global events' do
      @socket.bind('testevent') { |data| PusherClient.logger.test("testchannel received #{data}") }
      @socket.global_channel.callbacks.has_key?('testevent').should.equal true
    end

    it 'should trigger callbacks for global events' do
      @socket.bind('globalevent') { |data| PusherClient.logger.test("Global event!") }
      @socket.global_channel.callbacks.has_key?('globalevent').should.equal true

      @socket.simulate_received('globalevent', 'some data', '')
      PusherClient.logger.test_messages.last.should.include?('Global event!')
    end

    it 'should kill the connection thread when disconnect is called' do
      @socket.disconnect
      Thread.list.size.should.equal 1
    end

    it 'should not be connected after disconnecting' do
      @socket.disconnect
      @socket.connected.should.equal false
    end

    describe "when subscribed to a channel" do
      before do
        @channel = @socket.subscribe('testchannel')
      end

      it 'should allow binding of callbacks for the subscribed channel' do
        @socket['testchannel'].bind('testevent') { |data| PusherClient.logger.test(data) }
        @socket['testchannel'].callbacks.has_key?('testevent').should.equal true
      end

      it "should trigger channel callbacks when a message is received" do
        # Bind 2 events for the channel
        @socket['testchannel'].bind('coming') { |data| PusherClient.logger.test(data) }
        @socket['testchannel'].bind('going')  { |data| PusherClient.logger.test(data) }

        # Simulate the first event
        @socket.simulate_received('coming', 'Hello!', 'testchannel')
        PusherClient.logger.test_messages.last.should.include?('Hello!')

        # Simulate the second event
        @socket.simulate_received('going', 'Goodbye!', 'testchannel')
        PusherClient.logger.test_messages.last.should.include?('Goodbye!')
      end

    end
  end
end
