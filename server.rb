require 'rack'

class LiftOff
  attr_accessor :builder
  def initialize
    defm = Object.method(:define_method)
    builder = Rack::Builder.new
    middleware = {}
    %w[get post put delete].map{ |m|
      defm.(m) { |u,&b|
        builder.map(u) {
	  run ->(e) {
	    [200, {"Content-Type"=>"text/html"}, [builder.instance_eval(&middleware[u]).instance_eval(&b)]]
	  }
	}
      }
    }
    defm.("middle") { |p,&b|
      middleware[p] = b
    }
    @builder = builder
  end
end

server = LiftOff.new.builder

middle '/' do
  puts "middle"
end
get '/' do
  "Hello"
end

middle '/bye' do
  puts "middle"
end
post '/bye' do
  "Goodbye"
end

Rack::Handler::Thin.run server, :port => 3000
