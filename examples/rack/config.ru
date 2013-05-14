require 'errordite-rack'

use Errordite::Rack, context: {'Version' => '1.0.0'}

run lambda {|env|
  raise 'An example error'
}
