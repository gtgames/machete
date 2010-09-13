# encoding: utf-8
class Page
  include DataMapper::Resource

  property :id, Serial
  property :parent_id, Integer
  property :is_index, Boolean, :default => false
  property :is_home_page, Boolean, :default => false

  property :updated_at, DateTime
  property :created_at, DateTime

  unless MULTILANGUAGE_APP.nil?
    MULTILANGUAGE_APP.each do |lang|
      property "title_#{lang}".to_sym, String, :length => (1..128), :format => /[\w+\s*]*/u
      property "slug_#{lang}".to_sym, Slug
      property "text_#{lang}".to_sym, Text
      property "text_html__#{lang}".to_sym, Text
    end
    def title l = I18n.locale;     attribute_get "title_#{l}";     end
    def slug l = I18n.locale;      attribute_get "slug_#{l}";      end
    def text l = I18n.locale;      attribute_get "text_#{l}";      end
    def text_html l = I18n.locale; attribute_get "text_html_#{l}"; end


    before :save do
      MULTILANGUAGE_APP.each do |lang|
        attribute_set("text_html_#{lang}", RDiscount.new(eval("self.text_#{lang}")).to_html)
        attribute_set("slug_#{lang}", eval("self.title_#{lang}.to_slug"))
      end
    end
    def self.get_slug(data)
      first "slug_#{I18n.locale}".to_sym => data
    end
  else
    # non multilanguage
    property :title, String, :length => (1..128), :format => /[\w+\s*]*/u
    property :slug, Slug
    property :text, Text
    property :text_html, Text
    
    before :save do
      if self.text.size > 1
        attribute_set(:text_html, RDiscount.new(self.text).to_html)
        attribute_set(:is_index, true)
      end
      attribute_set(:slug, self.title.to_slug)
    end

    def self.get_slug(data)
      first :slug => data
    end
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