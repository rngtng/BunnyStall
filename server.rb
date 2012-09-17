require 'nabaztag_hack_kit/server'
require 'nabaztag_hack_kit/message/helper'

require 'graphite_stats'

module BunnyStall
  class Server < NabaztagHackKit::Server
    include GraphiteStats

    def initialize
      super public_file("bytecode.bin")
      @@key = nil
    end

    get "/key" do
      if key = params[:key]
        @@key = key.empty? ? nil : key
      end
      get_key
    end

    get "/streams/:file.mp3" do
      File.read public_file("#{params[:file]}.mp3")
    end

    #####################

    on "button-pressed" do |data, request|
      send_nabaztag koreo
    end

    on "ping" do |data, request|
      send_nabaztag begin
       token =
       if payment(get_key, "#{params[:token]}2y", params[:sn])
          koreo
        else
          NabaztagHackKit::Message::Helper::stop
        end
      end
    end

    private
    def public_file(name)
      File.expand_path(File.join('../public', name), __FILE__)
    end

    def koreo
      NabaztagHackKit::Message::Helper::wink.merge(
        NabaztagHackKit::Message::Helper::circle
      ).merge({
        PLAY_STREAM => "money.mp3"
      })
    end

    def get_key
      @@key || GraphiteStats::KEY
    end
  end
end
