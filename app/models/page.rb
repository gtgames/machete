# encoding: utf-8
class Page
  include DataMapper::Resource

  property :id, Serial
  property :parent_id, Integer, :required => false
  property :is_index, Boolean, :default => false
  property :is_home_page, Boolean, :default => false
  property :title, String, :length => (1..128), :format => /[\w+\s*]*/u
  property :slug, Slug
  property :text, Text
  property :text_html, Text
  property :updated_at, DateTime
  property :created_at, DateTime

  def is_home_page=(b)
    Page.all(:id.not => attribute_get(:id)).update(:is_home_page => false) if b
    attribute_set(:is_home_page, b)
  end
  
  def parent_id=(b)
    if (b=="NULL") 
      attribute_set(:parent_id, nil)
    else
      attribute_set(:parent_id, b)
    end
  end
  
  def self.home_page
    first :is_home_page => true
  end


  before :save do
    attribute_set(:text_html, BlueCloth.new(self.text).to_html)
    attribute_set(:slug, self.title.to_slug)
  end

  is :tree
  has_tags_on :tags
end