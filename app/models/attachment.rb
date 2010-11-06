require 'carrierwave/orm/sequel'
class Attachment < Sequel::Model
  many_to_one :page
  mount_uploader :file, AttachmentUploader
end
