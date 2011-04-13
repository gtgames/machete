class Photo
  include MongoMapper::Document
  plugin MongoMachete::Plugin::Taggable

  key :title, String
  key :file,  SimpleUploader
end
