require 'errordite/version'

module Errordite
  autoload :Client, 'errordite/client'
  autoload :Rack, 'errordite/rack'
  autoload :Serializer, 'errordite/serializer'

  class << self
    def api_token
      @api_token ||= ENV['ERRORDITE_TOKEN']
    end

    def api_token=(token)
      @api_token = token
    end

    def client
      @client ||= Client.new
    end

    def client=(client)
      @client = client
    end

    def record(error, context = {})
      client.send_json '/receiveerror', Serializer.new(error, context).to_json
    end

    def monitor(context = {})
      yield
    rescue Exception => e
      record e, context
    end
  end
end
