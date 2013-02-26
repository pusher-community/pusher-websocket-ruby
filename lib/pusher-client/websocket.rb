require 'rubygems'
require 'socket'
require 'websocket'
require 'openssl'

module PusherClient
  class PusherWebSocket
    attr_accessor :socket

    def initialize(url, params = {})
      @hs ||= WebSocket::Handshake::Client.new(:url => url, :version => params[:version])
      @frame ||= WebSocket::Frame::Incoming::Server.new(:version => @hs.version)
      @socket = TCPSocket.new(@hs.host, @hs.port || 80)

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

        @hs << data

        if @hs.finished?
          raise Exception unless @hs.valid?
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

      data = WebSocket::Frame::Outgoing::Server.new(version: @hs.version, data: data, type: :text).to_s
      @socket.write data
      @socket.flush
    end

    def receive
      raise "no handshake!" unless @handshaked

      begin
        data = @socket.read_nonblock(1024)
      rescue IO::WaitReadable
        IO.select([@socket])
        retry
      end
      @frame << data

      messages = []
      while message = @frame.next
        messages << message.to_s
      end
      messages
    end

    def close
      @socket.close
    end
  end
end
