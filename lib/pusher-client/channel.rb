module PusherClient

  class Channel
    attr_accessor :global, :subscribed
    attr_reader :name, :callbacks, :global_callbacks

    def initialize(channel_name, logger=PusherClient.logger)
      @name = channel_name
      @logger = logger
      @global = false
      @callbacks = {}
      @global_callbacks = {}
      @subscribed = false
    end

    def bind(event_name, &callback)
      @callbacks[event_name] = callbacks[event_name] || []
      @callbacks[event_name] << callback
      return self
    end

    def dispatch_with_all(event_name, data)
      dispatch(event_name, data)
      dispatch_global_callbacks(event_name, data)
    end

    def dispatch(event_name, data)
      logger.debug("Dispatching callbacks for #{event_name}")
      if @callbacks[event_name]
        @callbacks[event_name].each do |callback|
          callback.call(data)
        end
      else
        logger.debug("No callbacks to dispatch for #{event_name}")
      end
    end

    def dispatch_global_callbacks(event_name, data)
      if @global_callbacks[event_name]
        logger.debug("Dispatching global callbacks for #{event_name}")
        @global_callbacks[event_name].each do |callback|
          callback.call(data)
        end
      else
        logger.debug("No global callbacks to dispatch for #{event_name}")
      end
    end

    def acknowledge_subscription(data)
      @subscribed = true
    end

    private

    attr_reader :logger
  end

end
