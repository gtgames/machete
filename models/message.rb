class Message
  include MongoMapper::Document
  plugin Antispam

  key :author, String
  key :email, String
  key :phone, String
  key :text, String

  key :ip,  String, :default => lambda{ ENV['REMOTE_ADDR'] }
  key :ua,  String, :default => lambda{ ENV['HTTP_USER_AGENT'] }
  key :ref, String, :default => lambda{ ENV['HTTP_REFERER'] || '/' }

  alias :user_ip :ip
  alias :user_agent :ua
  alias :referrer :ref
  alias :comment_author :author
  alias :comment_author_email :email
  alias :comment_content :text

end
