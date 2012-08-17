#!/usr/bin/env ruby

# $LOAD_PATH.unshift ::File.expand_path(::File.dirname(__FILE__) + '/lib')
require 'nabaztag_hack_kit/server'

require './server'

use Rack::Reloader, 0

run Rack::URLMap.new("/" => BunnyStall::Server.new, "/api" => NabaztagHackKit::Server.new)

