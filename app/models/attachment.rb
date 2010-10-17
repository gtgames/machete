class Attachment < Sequel::Model
  many_to_one :page
end
