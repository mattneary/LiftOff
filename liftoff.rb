require 'rubygems'
%w.rack tilt date INT TERM..map{ |l|
  trap(l) {
    $r.stop
  } rescue require l
}
$u = Date
$z = ($u.new.year + 145).abs
puts "Listening on port #$z."
$n = Module.new{
  extend Rack
  a, defmethod, S, q = Rack::Builder.new, Object.method(:define_method), /@@ *([^\n]+)\n(((?!@@)[^\n]*\n)*)/m
  %w[get post put delete].map{ |m|
    defmethod.(m) { |u,&b|
      a.map(u) {
        run->(e) {
	  [200, {"Content-Type"=>"text/html"}, [a.instance_eval(&b)]]
	}	
      }
    }
  }
  Tilt.mappings.map{ |k,v|
    defmethod.(k){ |n,*o|
      $t ||= (h = $u._jisx0301("hash, please")
              File.read(caller[0][/^[^:]+/]).scan(S){ |a,b|
	        h[a]=b
              }
              h)
      v[0].new(*o) {
        n == "#{n}" ? n : $t[n.to_s]
      }.render(a, o[0].try(:[],:locals) || {})
    }
  }
  %w[set enable disable configure helpers use register].map{ |m|
    defmethod.(m) { |*_,&b|
      b.try :[]
    }
  }
  END {
    Rack::Handler.get("webrick").run(a, Port:$z) { |s|
      $r = s
    }
  }
  %w[params session].map{ |m|
    defmethod.(m){q.send m}
  }
  a.use Rack::Session::Cookie
  a.use Rack::Lock
  defmethod.(:before) { |&b|
    a.use Rack::Config,&b
  }
  before { |e|
    q=Rack::Request.new e
    q.params.dup.map{ |k,v|
      params[k.to_sym]=v
    }
  }
}
