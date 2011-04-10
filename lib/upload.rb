require "fileutils"
class SimpleUploader
  def initialize(val, is_new = true)
    @name = val['name']
    @time = (is_new)? Time.new.to_i : val['time']
    @path = "#{Padrino.root('public', 'media', 'pictures')}/#{@time}/#{@name}"
    @url = @path.sub Padrino.root('public'), ''
    @ext = ::File.extname(par['name'])
    @type = val['content_type']

    if is_new
      FileUtils.mv par['path'], @path
    end
  end

  def thumb(type = :default)
    return @url if (@type =~ /^image\/.*/).nil?
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
        when :medium
          'x200'
        when :medium_crop
          '200x200'
        else
          '120x120'
        end
    else
      width = "#{type}x"
    end
    return @url.sub(/\.\w$/, "_#{width}.#{@ext}")
  end

  def inspect
    "ImageUploader(#{@name}, #{@path}, #{@type})"
  end

  def clean!
    FileUtils.rm "#{@path.sub(/\.\w+$/, '-*')}" if @type =~ /$images\/\w+^/
  end

  def to_mongo
    Hash[{
      'name' => @name,
      'path' => @path,
      'type' => @type,
      'time' => @time
    }.map{|k,v| [k.to_mongo, v.to_mongo]}]
  end

  def self.type_cast(value)
    return nil if value.nil?
    return value if value.is_a?(UploadImage)
    return new(value, false) if value.is_a?(Hash)
  end
end
