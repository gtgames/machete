# encoding: utf-8

class Menu
  include DataMapper::Resource

  property :id, Serial
  is :localizable do
    property :title,  String, :length => 1..255
    property :alt,    String, :length => 1..255
  end
  property :url,    String,   :length => 1..255
  property :weigth, Integer,  :default => 10

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

end
