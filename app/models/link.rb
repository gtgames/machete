class Link
  include MongoMapper::Document
#  include MongoMapper::List
  
  key :title, String
  key :url,   String

end
