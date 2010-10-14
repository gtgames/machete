module Sinatra

  class Base
    def call!(env)
      @env      = env
      @request  = Request.new(env)
      @response = Response.new
      @params   = indifferent_params(@request.params)
      force_encoding(@params)

      invoke { dispatch! }
      invoke { error_block!(response.status) }

      status, header, body = @response.finish

      # Never produce a body on HEAD requests. Do retain the Content-Length
      # unless it's "0", in which case we assume it was calculated erroneously
      # for a manual HEAD response and remove it entirely.
      if @env['REQUEST_METHOD'] == 'HEAD'
        body = []
        header.delete('Content-Length') if header['Content-Length'] == '0'
      end

      [status, header, body]
    end
    
    private
      # Fixes encoding issues by
      # * defaulting to UTF-8
      # * casting params to Encoding.default_external
      #
      # The latter might not be necessary if Rack handles it one day.
      # Keep an eye on Rack's LH #100.
      if defined? Encoding
        Encoding.default_external = "UTF-8"
        Encoding.default_internal ||= Encoding.default_external

        def force_encoding(data)
          return if data == self
          if data.respond_to? :force_encoding
            data.force_encoding(Encoding.default_external)
          elsif data.respond_to? :each_value
            data.each_value { |v| force_encoding(v) }
          elsif data.respond_to? :each
            data.each { |v| force_encoding(v) }
          end
        end
      else
        def force_encoding(*) end
      end

  end #Base

end #Sinatra