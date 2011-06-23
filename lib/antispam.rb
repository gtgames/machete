module Antispam
  class Check
    include HTTParty
    headers 'User-Agent' =>'a_party/0.0.1 | Akismet/1.1',
            'Content-Type' =>'application/x-www-form-urlencoded'

    class << self
      attr_accessor :key_validated, :key, :blog

      def authorize(blog=Cfg['domain'], key=Cfg['antispam'], url='api.antispam.typepad.com')
        raise 'No API key set!' if key.nil?
        @@blog = blog
        @@key = key
        @@url = url
        default_options[:base_uri] = "http://#{@@url}"
        valid = self.post '/1.1/verify-key', :body=>{:key=>@@key, :blog=>@@blog}
        if valid == 'valid'
          @@key_validated = true
          default_options[:base_uri] = "http://#{@@key}.#{@@url}"
        else
          @@key_validated = false
        end
      end

      def is_spam?(object)
        raise 'Invalid API Key' unless @@key_validated == true
        body = {:blog=>@@blog}

        %w{user_ip user_agent referrer
           comment_type comment_author comment_author_url
           comment_content}.each do |attribute|
          body[attribute] = object.__send__(attribute) if object.respond_to?(attribute)
        end

        spam = self.post '/1.1/comment-check', :body=>body

        if spam == 'true'
          true
        elsif spam == 'false'
          false
        else
          raise spam # Missing params or somesuch
        end
      end
    end
  end

  extend ActiveSupport::Concern
  module InstanceMethods
    def is_spam
      Check.is_spam? self
    end
  end
end
