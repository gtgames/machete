require 'rubygems'
require 'i18n'

module Rack
  class LocaleSelector

    def initialize(app, options={})
      @app, @options = app, {
        :use_subdomain => true,
        :default_subdomain => "www",
        :default_locale => :en
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
        redirect!(get_locale)
      else
        a = @app.call(@env)
        response = Rack::Response.new(:body => a[2], :status => a[0], :header => a[1])
        response.set_cookie('locale', {
          :value => I18n.locale,
          :path => '/',
          :domain => @env["rack.session.options"][:domain]}) if get_cookie_locale != I18n.locale.to_s
        response.finish
      end if @request.get?
    end

    private

    # We need to set cookies domain to ".example.com" when using subdomains
    # check http://codetunes.com/2009/04/17/dynamic-cookie-domains-with-racks-middleware/
    def set_session_options!
      @env['rack.session.options'] = {} unless @env['rack.session.options']
      @env['rack.session.options'][:domain] = if @options[:use_subdomain]
        @options[:default_domain] ? @options[:default_domain] : unlocalized_host
      else
        @request.host
      end
    end

    def custom_domain?(host)
      domain = host.sub(/^\./, '')
      host !~ Regexp.new("#{domain}$", Regexp::IGNORECASE)
    end

    def deflect?
      locale = get_locale_from_request
      return !@options[:blacklist].include?(locale) unless !@options[:blacklist] or @options[:blacklist].empty?
      return !@options[:whitelist].include?(locale) unless !@options[:blacklist] or @options[:whitelist].empty?
      !set_locale(locale)
    end

    # Return SERVER_NAME subdomain (ie fr.example.com => fr)
    def get_locale_from_request
      if @options[:use_subdomain]
        host = @request.host.split(':').first if @env.has_key?('SERVER_NAME')
        return host.scan(/^(\w{2})(?=\.)/).flatten[0]
      end
      @env['PATH'].scan(/^\/(\w{2})\//).flatten[0] # exemple.com/fr => fr
    end

    def unlocalized_host
      host = @request.host.gsub(/^(\w{2})(?=\.)/, '')
      host.scan(/^\./) ? host : ".#{host}"
    end

    def get_locale
      get_cookie_locale || get_browser_locale || get_default_locale
    end

    def get_cookie_locale
      @request.cookies['locale']
    end

    def get_browser_locale
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
      location = if @options[:use_subdomain]
        if @request.url.scan(/^(\w{2})(?=\.)/)
          @env["HTTP_HOST"] = @env["SERVER_NAME"] = "#{locale}.#{@request.host}"
          @request.url
        else
          @request.url.gsub(/^(\w{2})(?=\.)/, locale)
        end
      else
        # TODO: find better regexp to match http://whatever.example.com/[EN]
        @request.url.gsub(/^\/(\w{2})\//, locale)
      end
      [301, {'Location' => location}, '']
    end

    def set_locale(locale)
      return false unless locale
      I18n.locale = @env['rack.locale'] = locale.to_sym
    end

  end
end
