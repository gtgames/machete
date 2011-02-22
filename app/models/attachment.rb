require 'carrierwave/orm/sequel'
class Attachment < Sequel::Model
  set_dataset dataset.reverse_order(:updated_at)

  one_to_one :pages
  mount_uploader :file, AttachmentUploader
end
