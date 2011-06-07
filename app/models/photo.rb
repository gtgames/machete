class Photo
  include MongoMapper::Document
  plugin MongoMachete::Taggable

  key :title, String

  key :file, SimpleUploader

end
