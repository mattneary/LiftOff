require_relative "liftoff"

configure do
  enable :sessions
end

helpers do
  def inc_counter
    session[:counter] ||= 0
    session[:counter] += 1
  end
end

before do
  puts " yay! got a request ".center(80, "=")
end

get '/' do
  @title = "Almost Sinatra"
  haml :index
end

# /hello?name=world
get '/hello' do
  erb :hello, locals: { name: params[:name] }
end

get '/counter' do
  inc_counter
  session[:counter].to_s
end

__END__

@@ index
%html
  %head
    %title= @title
  %body
    %a{:href => '/hello?name=World'} Say hello!
    %a{:href => '/counter'} Show Counter

@@ hello
Hello <%= name %>!
