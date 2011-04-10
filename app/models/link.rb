class Link
  include MongoODM::Document
  self.include_root_in_json = false

  field :title, String
  field :url,   String

end
