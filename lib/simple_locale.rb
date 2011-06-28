# TODO aggiungere il supporto alle sessioni

module Rack
  class AutoLocale
    def initialize(app, opts={})
      @app = app
      @blacklist = opts[:blacklist]
    end
    def call(env)
      @req = Rack::Request.new env

      if @req.env['REQUEST_URI'] == '/'
        return redirect(get_browser_locale)
      elsif @blacklist and @blacklist.include?(@req.env['REQUEST_URI'])
        @app.call env
      elsif @req.env['REQUEST_URI'].match(/^\/(\w{2})\//) && Cfg[:locales].include?($1)
        I18n.locale = $1.to_sym
        @app.call env
      else
        return redirect get_browser_locale, @req.env['REQUEST_URI']
      end
    end

    private
    def get_browser_locale
      if lang = @req.env['HTTP_ACCEPT_LANGUAGE']
        lang = lang.split(",").map { |l|
          l += ';q=1.0' unless l =~ /;q=\d+\.\d+$/
          l.split(';q=')
        }.first
        locale = @req.env['locale'] = lang.first.split("-").first
      else
        locale = @req.env['locale'] = Cfg.default_locale
      end
      locale
    end

    def redirect locale, path=''
      [301, {'Location' => "/#{locale}#{path}"}, '']
    end
  end
end

