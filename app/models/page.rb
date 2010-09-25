# encoding: utf-8
class Page
  include DataMapper::Resource

  property :id, Serial
  property :parent_id, Integer
  property :is_index, Boolean, :default => false
  property :is_home_page, Boolean, :default => false

  is :localizable do
    property :title, String, :length => (1..128), :format => /[\w+\s*]*/u
    property :slug, Slug
    property :text, Text
    property :text_html, Text

    before :save do
      attribute_set(:text_html, RDiscount.new(self.text).to_html)
      attribute_set(:slug, self.title.to_slug)
    end
  end

  property :updated_at, DateTime
  property :created_at, DateTime


  def self.get_slug(data)
    first :page_translations => [:slug => data]
  end

  def is_home_page=(b)
    Page.all(:id.not => attribute_get(:id)).update(:is_home_page => false) if b
    attribute_set(:is_home_page, b)
  end

  def self.home_page
    first :is_home_page => true
  end

  is :tree
  has_tags_on :tags
end