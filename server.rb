require 'nabaztag_hack_kit/server'
require 'nabaztag_hack_kit/mods/callback'
# require 'nabaztag_hack_kit/mods/logger'
require 'nabaztag_hack_kit/mods/playground'
require 'nabaztag_hack_kit/mods/button'
require 'nabaztag_hack_kit/mods/streaming'
require 'nabaztag_hack_kit/message/helper'

require 'graphite_stats'

module BunnyStall
  class Server < NabaztagHackKit::Server
    include GraphiteStats

    register NabaztagHackKit::Mods::Callback
    # register Mods::Logger
    register NabaztagHackKit::Mods::Playground
    register NabaztagHackKit::Mods::Button
    register NabaztagHackKit::Mods::Streaming

    def initialize
      super(:base_file => __FILE__)
      @@key = nil
      @@last_update = Time.now
    end

    get "/key" do
      if key = params[:key]
        @@key = key.empty? ? nil : key
      end
      get_key
    end

    #####################

    on "init" do |bunny, data, request|
      bunny.queue_commands(NabaztagHackKit::Message::Helper::circle(3).merge({
        NabaztagHackKit::Message::Api::PLAY_LOAD => "money.mp3",
      }))
    end

    on "button-pressed" do |bunny, duration|
      if bunny
        bunny.queue_commands((duration.to_i > 1000) ? koreo : NabaztagHackKit::Message::Helper::wink)
      end
    end

    on "request" do |_, data, request|
      if (Time.now - @@last_update) > 5
        if payment(get_key, "#{data[:token]}2y", nil)
          Bunny.all.each do |bunny|
            bunny.queue_commands koreo
          end
        end
        @@last_update = Time.now
      end
      nil
    end

    private
    def koreo
      NabaztagHackKit::Message::Helper::wink(1,4,3).merge(
        NabaztagHackKit::Message::Helper::circle(17)
      ).merge({
        NabaztagHackKit::Message::Api::PLAY_START => 1
      })
    end

    def get_key
      @@key || GraphiteStats::KEY
    end
  end
end
