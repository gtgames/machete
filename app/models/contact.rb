class Contact
  include MongoMapper::Document

  key :author, String
  key :email, String
  key :telephon, String
  key :text, String

  key :classification, String, :default => 'ham'
  
end
