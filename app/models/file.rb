class File
  include MongoMapper::Document

  key :url, String
  key :path, String
  key :content_type, String


  def thumb(type = :default)
    return self['url'] if /^image\/.*/.match(self['content_type']).nil?
    if type.is_a? Symbol
      width = case type
        when :mini
          '50x'
        when :mini_h
          'x50'
        when :mini_crop
          '50x50'
        when :small
          '100x'
        when :small_h
          'x100'
        when :small_crop
          '100x100'
        when :medium
          '200x'
        when :medium_h
          'x200'
        when :medium_crop
          '200x200'
        else
          '120x120'
        end
    else
      width = "#{type}x"
    end
    return self['url'].sub(/\.\w$/, "_#{width}.#{@ext}")
  end

  embeds :name, :profile_photo
end

class Post
  include MongoMapper::Document

  key :author, User
  key :title, String
  key :body, String
end