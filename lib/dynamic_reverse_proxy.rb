require 'rack/reverse_proxy'

module Rack
  class DynamicReverseProxy < ReverseProxy

    def call(env)
      path  = env['PATH_INFO']
      if path =~ /\/redirect/
        matcher, url = env['QUERY_STRING'].split("=")
        if matcher && !matcher.empty?
          if url && !url.empty?
            reverse_proxy matcher, url
          else
            remove_reverse_proxy matcher
          end
        end
        [200, {'Content-Type' => 'text/plain'}, Array(@matchers.map(&:to_s).join("\n"))]
      else
        super(env)
      end
    end

    private
    def remove_reverse_proxy(matcher)
      @matchers = @matchers.delete_if do |proxy|
        proxy.matching == matcher
      end
    end
  end
end
