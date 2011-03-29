class Page
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Document::Taggable
  acts_as_nested_set

  field :title, :type => String
  field :slug,  :type => String
  field :text,  :type => String

  index :slug , :unique => true
  
  before_save :generate_slug

  protected
  def generate_slug
    self.slug = title.to_ascii.downcase.gsub(/[^a-z0-9 ]/, ' ').strip.gsub(/[ ]+/, '-')
  end
  
end
