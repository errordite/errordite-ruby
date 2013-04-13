require 'errordite/version'

module Errordite
  class << self
    def api_token
      @api_token
    end

    def api_token=(token)
      @api_token = token
    end
  end

  self.api_token = ENV['ERRORDITE_TOKEN']
end
