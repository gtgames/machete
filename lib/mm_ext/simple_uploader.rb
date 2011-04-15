require "fileutils"
class SimpleUploader
  attr_reader :name, :type, :url

  def initialize(val)
    media_folder = "#{APP_ROOT}/public/media"
    is_new = Regexp.new(Regexp.escape(media_folder)).match(val['path']).nil?

    @name = val['name']
    @type = val['content_type'] ||= val['type']

    subfolder = (/^image\/.*/.match(@type).nil?)? 'assets' : 'pictures'

    @time = (! is_new)? val['time'] : Time.new.to_i
    @url  = (! is_new)? val['url']  : "/media/#{subfolder}/#{@time}/#{@name}"
    @path = (! is_new)? val['path'] : "#{media_folder}/#{subfolder}/#{@time}/#{@name}"
    @ext  = (! is_new)? val['ext']  : ::File.extname(val['name']).slice!(1..-1)

    if is_new
      FileUtils.mkdir_p ::File.dirname(@path)
      FileUtils.cp val['path'], @path
    end
  end

  def thumb(type = :default)
    return @url if /^image\/.*/.match(@type).nil?
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
    return @url.sub(/\.\w$/, "_#{width}.#{@ext}")
  end

  def inspect
    "ImageUploader(#{@name}, #{@path}, #{@type})"
  end

  def clean!
    FileUtils.rm "#{@path.sub(/\.\w+$/, '-*')}" if @type =~ /$images\/\w+^/
  end

  def to_h
    { 'name' => @name,
      'path' => @path,
      'url'  => @url,
      'ext'  => @ext,
      'type' => @type,
      'time' => @time
    }
  end

  def self.to_mongo(value)
    { 'name' => @name,
      'path' => @path,
      'url'  => @url,
      'ext'  => @ext,
      'type' => @type,
      'time' => @time
    }.merge!((value.is_a? Hash)? value : value.to_h)
  end

  def self.from_mongo(value)
    return nil if value.nil?
    return value if value.is_a?(SimpleUploader)
    return new(value) if value.is_a?(Hash)
  end
end
