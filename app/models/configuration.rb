class Configuration
  include MongoODM::Document
  self.include_root_in_json = false

  field :key
  field :value, String

end
