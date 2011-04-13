class Page
  include MongoMapper::Document
  plugin MongoMachete::Plugin::Taggable

  key :title, String
  key :lead,  String
  key :text,  String
  key :tags,  Array

  timestamps!
  def slug
    title.to_slug
  end

  if Configuration.translable?
    many :page_translation
    scope :by_slug,  lambda { |slug|
      where("page_translation.slug" => slug)
    }
  end
end

if Configuration.translable?
  class PageTranslation
    include MongoMapper::EmbeddedDocument

    key :lang,  String
    key :title, String
    key :lead,  String
    key :text,  String

  end
end