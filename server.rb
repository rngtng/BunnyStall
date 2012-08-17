require 'sinatra'

module BunnyStall
  class Server < Sinatra::Base
    get '/hi' do
      "Hello World!"
    end
  end
end
