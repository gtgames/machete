class Photo
  include MongoODM::Document
  self.include_root_in_json = false

  field :title, String
  field :file,  SimpleUploader
  field :tags,  Array
end
