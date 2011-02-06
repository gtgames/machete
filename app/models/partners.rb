require 'carrierwave/orm/sequel'
class Partner < Sequel::Model
  mount_uploader :file, PartnerUploader
end