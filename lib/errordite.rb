require 'errordite/version'

module Errordite
  autoload :Client, 'errordite/client'
  autoload :Config, 'errordite/config'
  autoload :Rack, 'errordite/rack'
  autoload :Serializer, 'errordite/serializer'

  class << self
    def config
      @config ||= Config.new
    end

    def config=(config)
      @config = config
    end

    def method_missing(method, *args)
      if config.respond_to?(method)
        config.__send__ method, *args
      else
        super
      end
    end

    def monitor(context = {})
      yield
    rescue Exception => e
      client.record e, context
      raise e
    end
  end
end
