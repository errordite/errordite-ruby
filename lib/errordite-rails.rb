require 'errordite'

class Errordite::Railtie < Rails::Railtie
  initializer "errordite.middleware" do |app|
    app.config.middleware.insert 0, "Errordite::Rack"
  end
end
