require 'nabaztag_hack_kit/server'
require 'nabaztag_hack_kit/message/helper'

require 'graphite_stats'

module BunnyStall
  class Server < NabaztagHackKit::Server
    include GraphiteStats

    def initialize
      super(:base_file => __FILE__)
      @@key = nil
    end

    get "/key" do
      if key = params[:key]
        @@key = key.empty? ? nil : key
      end
      get_key
    end

    #####################

    on "button-pressed" do |duration, request|
      send_nabaztag (duration.to_i > 1000) ? koreo : NabaztagHackKit::Message::Helper::wink
    end

    on "ping" do |data, request|
      send_nabaztag begin
       token = params[:token]
       if payment(get_key, "#{params[:token]}2y", params[:bunnyid])
          koreo
        else
          NabaztagHackKit::Message::Helper::stop
        end
      end
    end

    private
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
