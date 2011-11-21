$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', '..', 'lib'))
require 'rack'
require 'rack/test'
require 'simple_locale'
require 'riot'
require "ap"

class Cfg
 def self.[](any)
   ['it', 'en']
 end
 def self.default_locale
   'it'
 end
end
class I18n
  def self.locale=(l)
    puts "setting default locale to #{l}"
  end
end

def mock_get url
  app = lambda do |env|
    [
      200,
      { 'Content-Type' => 'text/plain'},
      env['PATH_INFO']
    ]
  end

  @request = Rack::MockRequest.env_for(url)

  @response = Rack::AutoLocale.new(app, {
    :host_blacklist => /^(www\.)?admin\..*$/,
    :blacklist  => ['/media','/sitemap.xml', '/sitemap', '']
  }).call(@request)
  #@status, @headers, @body
  @response
end


context "redirects on requests" do
  setup do
    mock_get '/'
  end
  
  asserts("it is not a 200") { topic[0] != 200 }
  asserts("it is a redirect") { topic[0] == 302 }
end

context "redirects existing url" do
  setup do
    mock_get '/en/foobar'
  end
  
  asserts("it is not redirect") { topic[0] != 302 }
  asserts("body is equal to requested url minus language path") { topic[2] == '/foobar' }
end

context "blacklists" do
  setup do
    mock_get '/media'
  end
  asserts("doesn't redirect on blacklist") { topic[0] == 200 }
  asserts("PATH_INFO is not touched in blacklists") { topic[2] == '/media' }
end
