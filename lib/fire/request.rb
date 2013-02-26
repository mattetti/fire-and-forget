require 'cgi'
require 'socket'
require 'uri'
begin
  require 'json' 
rescue LoadError
  puts "The json lib wasn't available, payload objects won't be automatically converted to json."
end

module FireAndForget
  class Request
    attr_reader :method, :url, :content_type, :payload, :headers, :callback

    def initialize(args)
      @method = args[:method] || raise(ArgumentError.new("must pass :method"))
      @headers = args[:headers] || {}
      raise ArgumentError, ":headers should be nil or a Hash" unless (@headers.respond_to?(:keys) && @headers.respond_to?(:each))
      @content_type = args[:content_type] || headers['Content-Type'] || "application/json"
      @headers = {'Content-Type' => @content_type}.merge(headers)
      if args[:url]
        @url = args[:url]
      else
        raise ArgumentError, "must pass :url"
      end
      @callback = args[:callback]
      @payload = args[:payload]
      @args = args
    end

    def execute
      uri = URI.parse(url)
      req = []
      req << "#{method.respond_to?(:upcase) ? method.upcase : method.to_s.upcase} #{uri.request_uri} HTTP/1.0"
      if uri.port != 80
        req << "Host: #{uri.host}:#{uri.port}"
      else
        req << "Host: #{uri.host}"
      end
      req << "User-Agent: FAF #{FireAndForget::VERSION}"
      req << "Accept: */*"
      processed_headers.each do |part|
        req << part
      end
      req << "Content-Length: #{body_length}"

      socket = TCPSocket.open(uri.host, uri.port)
      req.each do |req_part|
        socket.puts(req_part + "\r\n")
      end
      #puts (req << body).inspect
      socket.puts "\r\n"
      socket.puts body
      # For debugging purposes you can pass a block to read the socket or sleep for a bit.
      # You can also set a callback when creating the instance and it will be called passing the socket.
      if callback
        callback.call(socket)
      elsif block_given?
        yield(socket)
      end
      ensure
      socket.close if socket
    end

    def body
      if @body
        @body
      else
        if payload.nil?
          @body = ""
        elsif payload.is_a?(String)
          @body = payload
        elsif payload.respond_to?(:to_json)
          @body = payload.to_json
        else
          @body = ""
        end
      end
    end

    def body_length
      body ? body.bytesize : 0
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
