require 'rubygems'
require 'socket'
require 'libwebsocket'
require 'openssl'

module PusherClient
  class WebSocket

    def initialize(url, params = {})
      @hs ||= LibWebSocket::OpeningHandshake::Client.new(:url => url, :version => params[:version])
      @frame ||= LibWebSocket::Frame.new

      @socket = TCPSocket.new(@hs.url.host, @hs.url.port || 80)

      if params[:ssl] == true

        ctx = OpenSSL::SSL::SSLContext.new
        ctx.verify_mode = OpenSSL::SSL::VERIFY_PEER|OpenSSL::SSL::VERIFY_FAIL_IF_NO_PEER_CERT
        # http://curl.haxx.se/ca/cacert.pem
        ctx.ca_file = path_to_cert()

        ssl_sock = OpenSSL::SSL::SSLSocket.new(@socket, ctx)
        ssl_sock.sync_close = true
        ssl_sock.connect

        @socket = ssl_sock

      end

      @socket.write(@hs.to_s)
      @socket.flush

      loop do
        data = @socket.getc
        next if data.nil?

        result = @hs.parse(data.chr)

        raise @hs.error unless result

        if @hs.done?
          @handshaked = true
          break
        end
      end
    end

    def path_to_cert
      File.join(File.dirname(File.expand_path(__FILE__)), '../../certs/cacert.pem')
    end

    def send(data)
      raise "no handshake!" unless @handshaked

      data = @frame.new(data).to_s
      @socket.write data
      @socket.flush
    end

    def receive
      raise "no handshake!" unless @handshaked

      data = @socket.gets("\xff")
      @frame.append(data)

      messages = []
      while message = @frame.next
        messages << message
      end
      messages
    end

    def socket
      @socket
    end

    def close
      @socket.close
    end

  end
end


