require "time"
require "rack/utils"

module Rack
  module Less
    attr_accessor :lessc

    def initialize(app, lesspath=`which lessc`)
      @lessc = lesspath
    end

    def compile(file)
      IO.popen("#{@lessc} #{file}")
    end

    def call(env)
      path = Utils.unescape(env["PATH_INFO"])
      return [403, {"Content-Type" => "text/plain"}, ["Forbidden\n"]] if path.include?('..')
      return @app.call(env) unless urls.any?{|url| path.index(url) == 0} and (path =~ /\.css$/)

      less = ::File.join(root, path.sub(/\.css$/,'.less'))

      if ::File.file?(less)
        modified = ::File.mtime less
        if env['HTTP_IF_MODIFIED_SINCE']
          cached = Time.parse(env['HTTP_IF_MODIFIED_SINCE'])
          if modified <= cached
            return [304, {}, 'Not modified']
          end
        end

        headers = {"Content-Type" => "text/stylesheet", "Last-Modified" => ::File.mtime(less).httpdate}

        headers['Cache-Control'] = "max-age=360000"
        headers['Cache-Control'] << ', public'
        [200, headers, compile(less)]
      else
        @server.call(env)
      end

    end
  end
end
