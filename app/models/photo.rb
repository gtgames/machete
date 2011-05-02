class Photo
  include MongoMapper::Document
  plugin MongoMachete::Taggable

  key :title, String

  one :media_file

end
