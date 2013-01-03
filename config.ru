#!/usr/bin/env ruby

$LOAD_PATH.unshift ::File.expand_path(::File.dirname(__FILE__) + '/lib')
require './server'
require 'dynamic_reverse_proxy'

$stdout.sync = true

use Rack::Reloader, 0
use Rack::DynamicReverseProxy

run BunnyStall::Server.new
