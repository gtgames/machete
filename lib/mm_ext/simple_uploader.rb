require "fileutils"
class SimpleUploader < HashWithIndifferentAccess
  def initialize(*args)
    super(*args)
    return nil if self['name'].nil? or self['name'].size < 1

    media_folder = "#{APP_ROOT}/public/media"
    is_new = !! Regexp.new(Regexp.escape(media_folder)).match(self['path']).nil?

    return self if !is_new

    tempfile = self["path"]
    subfolder = (/^image\/.*/.match(self['content_type']).nil?)? 'assets' : 'pictures'

    self["time"] = ::Time.new.to_i
    self["url"]  = "/media/#{subfolder}/#{self['time']}/#{self["name"]}"
    self["path"] = "#{media_folder}/#{subfolder}/#{self['time']}/#{self['name']}"
    self["ext"]  = ::File.extname(self['name']).slice!(1..-1)

    FileUtils.mkdir_p ::File.dirname(self['path'])
    FileUtils.cp tempfile, self['path']

    return self
  end

  def thumb(type = :default)
    if (self['content_type'] =~ /^image\/.*/).nil?
      return self['url']
    end
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
    return self['url'].sub(/\.\w+$/, "_#{width}.#{self['ext']}")
  end

  def inspect
    "ImageUploader(#{self['name']}, #{self['path']}, #{self['type']})"
  end

  def clean!
    FileUtils.rm "#{self['path'].sub(/\.\w+$/, '-*')}" if self['content_type'] =~ /$images\/\w+^/
  end

  def to_s
    self['url']
  end

  def self.from_mongo(value)
    SimpleUploader.new(value || {})
  end
end
