##
# This extension give to padrino the ability to change
# their locale inspecting.
#
# ==== Usage
#
#   class MyApp < Padrino::Application
#     register Frenz::AutoLocale
#     set :locales, [:en, :ru, :de] # First locale is the default locale
#   end
#
# So when we call an url like: /ru/blog/posts this extension set for you :ru as I18n.locale
# to add more spice you can define your controllers like:
#
#   MyApp.controllers :foo, :lang => I18n.locale do
#     get :index, :map => '/:lang/' do
#       render 'foo/foo'
#     end
#   end
#
module Frenz
  module AutoLocale
    module Helpers
      ##
      # This reload the page changing the I18n.locale
      #
      def switch_to_lang(lang)
        request.path_info.sub(/\/#{I18n.locale}/, "/#{lang}") if options.locales.include?(lang)
      end

      def get_browser_locale
        # http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.4
        if lang = request.env['HTTP_ACCEPT_LANGUAGE']
          lang = lang.split(",").map { |l|
            l += ';q=1.0' unless l =~ /;q=\d+\.\d+$/
            l.split(';q=')
          }.first
          locale = request.env['locale'] = lang.first.split("-").first
        else
          locale = request.env['locale'] = I18n.default_locale
        end
        locale
      end

    end # Helpers

    def self.registered(app)
      app.helpers Frenz::AutoLocale::Helpers
      #app.set :locales, [:en]
      app.before do
        if request.env['REQUEST_URI'] == '/'
          redirect "/#{get_browser_locale}/"
        elsif request.path_info =~ /^\/(#{options.locales.join('|')})\/?/
          I18n.locale = $1.to_sym
        else
          redirect request.env['REQUEST_URI'].sub /^\/(\w{2})\//, '/en/'
        end
      end
    end # self.registered
  end # AutoLocale
end # Frenz
