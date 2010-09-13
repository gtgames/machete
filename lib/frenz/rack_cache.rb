module Frenz
  module RackCache

    def self.registered(app)
      app.before do
        if request.get? and !request.path.match(/\.js(?:on)?$/) and PADRINO_ENV == "production"
          begin
            cache_time = File::mtime("#{PADRINO_ROOT}/.cache")
          rescue Errno::ENOENT
            FileUtils::touch("#{PADRINO_ROOT}/.cache")
            cache_time = File::mtime("#{PADRINO_ROOT}/.cache")
          end
          headers 'Cache-Control' => "max-age=300, public"
          headers 'Last-Modified' => cache_time.httpdate
        else #assuming ajax/development
          headers 'Cache-Control' => "max-age=0, no-cache, must-revalidate"
          headers 'Last-Modified' => Time.now.httpdate
        end
      end
    end
  end
end
