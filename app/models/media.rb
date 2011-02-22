require 'carrierwave/orm/sequel'
class Media < Sequel::Model
  set_dataset dataset.order(:type)

  def_dataset_method :full_text_search
  mount_uploader :file, MediaUploader

  def before_save
    self.type = `file -b --mime-type #{self.file.file.file}`.split('/').first
    super
  end
end
