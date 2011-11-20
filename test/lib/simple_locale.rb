$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', '..', 'lib'))
require 'rack'
require 'rack/test'
require 'simple_locale'
require 'riot'
require "ap"

app = lambda do |env|
  [
    200,
    {
      'Content-Type' => 'text/plain',
      'Content-Length' => env['PATH_INFO'].length,
    },
    env['PATH_INFO']
  ]
end
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


context "redirects on " do
  setup do
    @request = Rack::MockRequest.env_for("/")

    @response = Rack::AutoLocale.new(app, {
      :host_blacklist => /^(www\.)?admin\..*$/,
      :blacklist  => ['/media','/sitemap.xml', '/sitemap']
    }).call(@request)
    #@status, @headers, @body
    @response
  end
  
  asserts("it is a redirect") { topic[0] == 302 }
end

context "cleaup redirection path" do
  setup do
    @request = Rack::MockRequest.env_for("/en/foobar")

    @response = Rack::AutoLocale.new(app, {
      :host_blacklist => /^(www\.)?admin\..*$/,
      :blacklist  => ['/media','/sitemap.xml', '/sitemap']
    }).call(@request)
    #@status, @headers, @body
    @response
  end
  
  asserts("it is not redirect") { topic[0] != 302 }
  asserts("body is equal to requested url minus language path") {
    topic[2] == '/foobar' }
end
