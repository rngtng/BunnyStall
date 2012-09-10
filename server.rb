require 'sinatra'

require 'nabaztag_hack_kit/server'
module BunnyStall
  class Server < NabaztagHackKit::Server

    on :ping do
    end
  end
end
