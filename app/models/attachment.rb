require 'carrierwave/orm/sequel'
class Attachment < Sequel::Model
  one_to_one :pages
  mount_uploader :file, AttachmentUploader
end
