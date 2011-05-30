require 'i18n'
require 'pp'
module Rack
  class LocaleSelector

    def initialize(app, options={})
      @app, @options = app, {
        :default_locale => :it,
        :whitelist => [:it]
      }.merge(options)
      yield self if block_given?
    end

    def call(env)
      @env = env
      @request = Rack::Request.new(@env)

      set_session_options!

      if @request.post? || @request.put? || @request.delete?
        @app.call(env)
      elsif deflect?
        puts 'deflecting'
        redirect!(get_locale)
      else
        puts 'calling'
        puts get_locale
        a = @app.call(@env)
        pp a
        #response = Rack::Response.new(:body => a[2], :status => a[0],
        #:header => a[1])
        response = Rack::Response.new(a)
        response.set_cookie('locale', {
                              :value => I18n.locale,
                              :path => '/',
                              :domain => @env["rack.session.options"][:domain]
                            }) if get_cookie_locale != I18n.locale.to_s
        response.finish
      end
    end

    private

    # We need to set cookies domain to ".example.com" when using subdomains
    # check http://codetunes.com/2009/04/17/dynamic-cookie-domains-with-racks-middleware/
    def set_session_options!
      @env['rack.session.options'] = {} unless @env['rack.session.options']
      @env['rack.session.options'][:domain] = @request.host
    end

    def deflect?
      locale = get_locale_from_request
      return !@options[:blacklist].include?(locale) unless !@options[:blacklist] or @options[:blacklist].empty?
      return !@options[:whitelist].include?(locale) unless !@options[:blacklist] or @options[:whitelist].empty?
      !set_locale(locale)
    end

    def get_locale_from_request
      @env['PATH_INFO'].scan(/^\/(\w{2})\//).flatten[0] unless @env['PATH_INFO'].nil?
    end

    def get_locale
      get_cookie_locale || get_browser_locale || get_default_locale
    end

    def get_cookie_locale
      @request.cookies['locale']
    end

    def get_browser_locale
      # curl doesn't send ACCEPTED_LANGUAGE :O
      return @options[:default_locale] if @env['HTTP_ACCEPT_LANGUAGE'].nil?

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

    def redirect!(locale)
      # FIXME: find better regexp to match
      # http://whatever.example.com/[EN]
      pp @request.path_info
      #location = @request.url.sub(/^\/(\w{2})\//, locale.to_s)
      location = "/#{locale}/"
      [301, {'Location' => location}, '']
    end

    def set_locale(locale)
      return false unless locale
      I18n.locale = @env['rack.locale'] = locale.to_sym
    end

  end
end
