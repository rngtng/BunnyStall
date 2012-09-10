require 'nabaztag_hack_kit/server'
require 'nabaztag_hack_kit/message/helper'

require 'graphite_stats'

module BunnyStall
  class Server < NabaztagHackKit::Server
    include GraphiteStats

    def initialize
      super public_file("bytecode.bin")
    end

    get "/streams/:file.mp3" do
      path = public_file("#{params[:file]}.mp3")
      puts path
      File.read(path)
    end


    on "button-pressed" do |data, request|
      send_nabaztag({
          PLAY_STREAM => "money.mp3",
      #   LED_L1   => [0],
      #   LED_L2   => [0],
      #   LED_L3   => [0],
          LED_L4   => [0,0,0,0,100],
      })
    end

    on "ping" do |data, request|
      send_nabaztag begin
       if payment(GraphiteStats::KEY, params[:password])
          NabaztagHackKit::Message::Helper::wink.merge(
            NabaztagHackKit::Message::Helper::circle
          ).merge({
            PLAY_STREAM => "money.mp3"
          })
        else
          NabaztagHackKit::Message::Helper::stop
        end
      end
    end

    private
    def public_file(name)
      File.expand_path(File.join('../public', name), __FILE__)
    end
  end
end
