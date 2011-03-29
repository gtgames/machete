require 'carrierwave/orm/mongoid'
require File.join Padrino.root('app/uploaders'), 'headline'
class Post
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields
  include Mongoid::Document::Taggable

  mount_uploader :photo, HeadlineUploader

  field :title, :type => String
  field :text, :type => String

  index :slug , :unique => true
  
  before_create :generate_slug

  protected
  def generate_slug
    self[:slug] = title.to_ascii.downcase.gsub(/[^a-z0-9 ]/, ' ').strip.gsub(/[ ]+/, '-')
  end
  
end
