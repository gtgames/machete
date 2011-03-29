class Configuration
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields

  field :key, :type => String
  field :value, :type => String

  index :key , :unique => true
end
