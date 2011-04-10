require 'time'
require 'rack/file'
require 'rack/utils'

module Rack
  class Less
    attr_accessor :urls, :root
    DEFAULTS = {:static => true}
    
    def initialize(app, opts={})
      opts = DEFAULTS.merge(opts)
      @app = app
      @urls = *opts[:urls] || '/stylesheets'
      @root = opts[:root] || Dir.pwd
      @server = opts[:static] ? Rack::File.new(root) : app
      @cache = opts[:cache]
      @ttl = opts[:ttl] || 86400
      @command = ['lessc']
      @command = @command.join(' ')
    end
    
    def brew(less)
      IO.popen("#{@command} #{less}")
    end
    
    def call(env)
      path = Utils.unescape(env["PATH_INFO"])
      return [403, {"Content-Type" => "text/plain"}, ["Forbidden\n"]] if path.include?('..')
      return @app.call(env) unless urls.any?{|url| path.index(url) == 0} and (path =~ /\.js$/)
      coffee = F.join(root, path.sub(/\.css$/,'.less'))
      if F.file?(coffee)

        modified_time = ::File.mtime(coffee)

        if env['HTTP_IF_MODIFIED_SINCE']
          cached_time = Time.parse(env['HTTP_IF_MODIFIED_SINCE'])
          if modified_time <= cached_time
            return [304, {}, ['Not modified']]
          end
        end

        headers = {"Content-Type" => "text/stylesheet", "Last-Modified" => F.mtime(coffee).httpdate}
        if @cache
          headers['Cache-Control'] = "max-age=#{@ttl}"
          headers['Cache-Control'] << ', public' if @cache == :public
        end
        [200, headers, brew(coffee)]
      else
        @server.call(env)
      end
    end
  end
end