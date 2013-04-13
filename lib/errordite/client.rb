require 'net/http'

class Errordite::Client
  attr_reader :key

  def initialize(key, server = 'www.errordite.com', port = 443)
    @key = key
    @server = server
    @port = port
  end

  def send(message)
    body = error.to_json
    connection.post '/receiveerror', body, 'Content-Type' => 'application/json; charset=utf-8', 'Content-Length' => body.size.to_s
  end

  private

  def connection
    http = Net::HTTP.new @server, @port
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    http
  end
end