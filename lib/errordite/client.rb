require 'net/http'

class Errordite::Client
  attr_reader :server, :port

  def initialize(server = 'www.errordite.com', port = 443)
    @server = server
    @port = port
  end

  def send_json(path, body)
    Connection.new(server, port).post path, body, 'Content-Type' => 'application/json; charset=utf-8', 'Content-Length' => body.size.to_s
  end

  class Connection
    def initialize(server, port)
      @http = Net::HTTP.new server, port
      @http.use_ssl = true
      @http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    end

    def post(*args)
      @http.post(*args)
    end
  end
end