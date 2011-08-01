class Event
  include MongoMapper::Document

  key :title, String
  key :description, String

  key :from, Time, :default => lambda{ Time.now }
  key :to, Time, :default => lambda { Time.now }

  key :file, MediaFile::Embeddable
end
