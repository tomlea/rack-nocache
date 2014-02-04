module Rack
  
  class Nocache
    
    require 'date'
    require 'cgi'
    
    def initialize(app)
      @app = app
    end

    def call(env)
      status, headers, body = @app.call(patch_request_headers(env))
      [status, patch_response_headers(headers), body]
    end

  protected

    old_date = Time.now - 3600 * 24 * 365 * 25
    new_date = Date.today.to_time - 3600 * 24 * 30
    date = Time.at((new_date - old_date)*rand + old_date.to_f)
    
    CACHE_BUSTER = {
      "Cache-Control" => "no-cache, no-store, max-age=0, must-revalidate",
      "Pragma" => "no-cache",
      "Expires" => CGI.rfc1123_date(date)
    }

    def patch_request_headers(env)
      env.reject{|k,v| k =~ /^HTTP_IF/i }
    end

    def patch_response_headers(env)
      env.reject{|k,v| k =~ /^ETag$/i }.merge(CACHE_BUSTER)
    end
    
  end

end
