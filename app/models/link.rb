class Link
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields
  acts_as_nested_set

  field :title, :type => String
  field :url, :type => String

  # You can define indexes on documents using the index macro:
  # index :field <, :unique => true>

  # You can create a composite key in mongoid to replace the default id using the key macro:
  # key :field <, :another_field, :one_more ....>

end
