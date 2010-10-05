# encoding: utf-8
class Menu
  include DataMapper::Resource

  property :id, Serial
  property :title,  String, :length => 1..255
  property :alt,    String, :length => 1..255
  property :url,    String,   :length => 1..255
  property :weigth, Integer,  :default => 10

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
