require 'carrierwave/orm/mongoid'
require File.join Padrino.root('app/uploaders'), 'photo'
class Photo
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields

  mount_uploader :file, PhotoUploader
  field :title, :type => String

end
