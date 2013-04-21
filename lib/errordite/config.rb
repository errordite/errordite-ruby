require 'errordite'

class Errordite::Config
  def api_token
    @api_token ||= ENV['ERRORDITE_TOKEN']
  end

  def api_token=(token)
    @api_token = token
  end

  def server
    @server ||= 'www.errordite.com'
  end

  def server=(s)
    @server = s
  end

  def port
    @port ||= 443
  end

  def port=(p)
    @port = p
  end

  def client
    @client ||= Errordite::Client.new(server, port)
  end

  def client=(client)
    @client = client
  end
end