require 'rubygems'
require 'i18n'

module Rack
  class LocaleSetter
    def initialize(app)
      @app = app
    end

    def call(env)
      @env = env
      req = Rack::Request.new(@env)
      if m = req.host.match(/^(?:www\.)?([a-z]{2})\./) or req.path.match(/^([a-z]{2})\./)
        locale = m[1]
      else
        locale = browser_locale
      end
      req.params['locale'] ||= locale
      I18n.locale = locale
      @app.call env
    end

    protected

    def browser_locale
      # http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.4
      if lang = @env['HTTP_ACCEPT_LANGUAGE']
        lang = lang.split(",").map { |l|
          l += ';q=1.0' unless l =~ /;q=\d+\.\d+$/
          l.split(';q=')
        }.first
        locale = @env['rack.locale'] = lang.first.split("-").first
      else
        locale = @env['rack.locale'] = I18n.default_locale
      end
      locale
    end

  end
end
