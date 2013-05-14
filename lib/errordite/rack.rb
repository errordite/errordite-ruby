require 'errordite'
require 'rack/request'

class Errordite::Rack
  def initialize(app, options = {})
    @app = app
    @context = options[:context] || {}
  end

  def call(env)
    Errordite.monitor rack_context(env).merge(@context) do
      @app.call(env)
    end
  end

  private

  def rack_context(env)
    request = Rack::Request.new(env)
    {'Url' => request.url, 'UserAgent' => env['HTTP_USER_AGENT']}
  end
end
