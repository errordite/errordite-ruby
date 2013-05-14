require 'net/http'

class Errordite::Client
  attr_reader :server, :port, :logger

  def initialize(server = 'www.errordite.com', port = 443, logger = Errordite.logger)
    @server = server
    @port = port
    @logger = logger
  end

  def record(error, context)
    post_json '/receiveerror', Errordite::Serializer.new(error, context).to_json
  end

  def post_json(path, body)
    headers = {'Content-Type' => 'application/json; charset=utf-8', 'Content-Length' => body.size.to_s}
    response = Connection.new(server, port).post path, body, headers
    log_response response
    response
  end

  private

  def log_response(response)
    if response.code != "201"
      logger.warn "Failed to log error: #{response.code} #{response.message}"
    elsif logger.debug?
      logger.debug "Error logged: #{response.code} #{response.message}"
    end
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
