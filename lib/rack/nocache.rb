module Rack
  class Nocache
    def initialize(app)
      @app = app
    end

    def call(env)
      status, headers, body = @app.call(patch_request_headers(env))
      [status, patch_response_headers(headers), body]
    end

  protected
    CACHE_BUSTER = {
      "Cache-Control" => "no-cache, no-store, max-age=0, must-revalidate",
      "Pragma" => "no-cache",
      "Expires" => "Fri, 29 Aug 1997 02:14:00 EST"
    }

    def patch_request_headers(env)
      env.reject{|k,v| k =~ /^HTTP_IF/i }
    end

    def patch_response_headers(env)
      env.reject{|k,v| k =~ /^ETag$/i }.merge(CACHE_BUSTER)
    end
  end
end
