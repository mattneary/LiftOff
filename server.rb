require 'rack'

class LiftOff
  attr_accessor :defm, :builder
  def initialize
    defm = Object.method(:define_method)
    builder = Rack::Builder.new
    %w[get post put delete].map{ |m|
      defm.(m) { |u,&b|
        builder.map(u) {
	  run ->(e) {
	    [200, {"Content-Type"=>"text/html"}, [builder.instance_eval(&b)]]
	  }
	}
      }
    }
    @builder = builder
  end
end

server = LiftOff.new.builder

get '/' do
  "Hello"
end

post '/bye' do
  "Goodbye"
end

Rack::Handler::Thin.run server, :port => 3000
