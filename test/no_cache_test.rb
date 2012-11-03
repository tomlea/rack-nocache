require "test/unit"
$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "rack"
require "rack-nocache"
require "active_support"

class TestRackNocache < Test::Unit::TestCase
  def setup
    @response_headers_in = {}
  end

  def go!(env = {})
    _, @response_headers_out, _ = Rack::Nocache.new(lambda{|env| @env = env; [200, @response_headers_in, []] }).call(env)
  end

  def test_should_delete_If_bla_headers
    go!("HTTP_IF_SOME_FOO" => "foo")
    assert_nil @env["HTTP_IF_SOME_FOO"]
  end

  def test_should_set_cache_busting_headers
    go!
    assert_equal Rack::Nocache::CACHE_BUSTER.values, @response_headers_out.values_at(*Rack::Nocache::CACHE_BUSTER.keys)
  end

  def test_should_delete_etag_in_response
    @response_headers_in = {"ETag" => "foo"}
    go!
    assert_nil @response_headers_out["ETag"]
  end

  def test_should_leave_everything_else_alone
    @response_headers_in = {"Foo" => "Bar"}
    go!
    assert_equal "Bar", @response_headers_out["Foo"]
  end

end
