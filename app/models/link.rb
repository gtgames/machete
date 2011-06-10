class Link
  include MongoMapper::Document
  plugin MongoMapper::Plugins::HashParameterAttributes
#  include MongoMapper::List

  key :title, Translation
  key :url,   Translation
end
