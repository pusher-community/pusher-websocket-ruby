module PusherClient
  class Channels

    attr_reader :channels

    def initialize
      @channels = {}
    end

    def add(channel_name)
      unless @channels[channel_name]
        @channels[channel_name] = Channel.new(channel_name)
      end
      @channels[channel_name]
    end

    def find(channel_name)
      @channels[channel_name]
    end

    def remove(channel_name)
      @channels.delete(channel_name)
      @channels
    end

    def empty?
      @channels.empty?
    end

    def size
      @channels.size
    end

    alias :<< :add
    alias :[] :find

  end
end
