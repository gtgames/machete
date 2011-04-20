class File
  include MongoMapper::Document

  key :url, String
  key :path, String
  key :content_type, String

  embeds :url, :content_type
end
