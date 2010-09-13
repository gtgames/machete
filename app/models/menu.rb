# encoding: utf-8

class Menu
  include DataMapper::Resource

  property :id, Serial

  property :title_en, String
  property :title_es, String
  property :title_it, String
  property :title_fr, String

  property :alt_en, String
  property :alt_es, String
  property :alt_it, String
  property :alt_fr, String

  property :url, String, :length => 1..255
  property :weigth, Integer, :default => 10

  def iurl
    url = attribute_get(:url)
    if url =~ /^\/\w*[\w\d\/]*/
      "/#{I18n.locale}#{url}"
    else
      url
    end
  end

  def url=(data)
    if data =~ /^(http:\/)?\/.*/
      data 
    elsif data =~ /^(www\.)?[A-Za-z\.]*\.[a-zA-Z]{2,4}(\/)?/
      data = "http://#{data}"
    else
      data = "/#{data}"
    end
    attribute_set(:url, data)
  end

  def title
    attribute_get "title_#{I18n.locale}".to_sym
  end

  def alt
    attribute_get "title_#{I18n.locale}".to_sym
  end

end
