require 'cgi'
require 'socket'
require 'uri'
require 'json'

module FireAndForget
  class Request
    attr_reader :method, :url, :content_type, :payload, :headers

    def initialize(args)
      @method = args[:method] or raise ArgumentError, "must pass :method"
      @headers = args[:headers] || {}
      @content_type = args[:content_type] || "application/json"
      if args[:url]
        @url = args[:url]
      else
        raise ArgumentError, "must pass :url"
      end
      @payload = args[:payload]
      @args = args
    end

    def execute
      uri = URI.parse(url)
      req = []
      req << "#{method.upcase} #{uri.request_uri} HTTP/1.0"
      req << "Host: #{uri.host}:#{uri.port}"
      req << "Content-Type: #{content_type}"
      req << "Content-Length: #{body_length}"
      processed_headers.each do |part|
        req << part
      end

      socket = TCPSocket.open(uri.host, uri.port)
      req.each do |req_part|
        socket.puts(req_part + "\r\n")
      end
      #puts (req << body).inspect
      socket.puts "\r\n"
      socket.puts body
      ensure
      socket.close if socket
    end

    def body
      @body ||= if @payload
                  @payload.is_a?(String) ? @payload : @payload.to_json
                else
                  ""
                end
    end

    def body_length
      body ? body.length : 0
    end

    def processed_headers
      chunks = []
      headers.each do |key, value|
        if key.is_a? Symbol
          key = key.to_s.split(/_/).map { |w| w.capitalize }.join('-')
        end
        chunks << "#{key}: #{value.to_s}"
      end
      chunks
    end

  end
end
