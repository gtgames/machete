class Message
  include MongoMapper::Document
  plugin Antispam
  timestamps!

  key :author, String
  key :email, String
  key :phone, String
  key :text, String

  # state
  key :st, Integer, :default => 1 # 1  - unread state
                                  # 0  - read
                                  # -1 - deleted

  key :ip,  String, :default => lambda{ ENV['REMOTE_ADDR'] }
  key :ua,  String, :default => lambda{ ENV['HTTP_USER_AGENT'] }
  key :ref, String, :default => lambda{ ENV['HTTP_REFERER'] || '/' }

  alias :user_ip :ip
  alias :user_agent :ua
  alias :referrer :ref
  alias :comment_author :author
  alias :comment_author_email :email
  alias :comment_content :text

  def text=(t)
    self['text'] = Rack::Utils.escape_html(t)
  end
end
