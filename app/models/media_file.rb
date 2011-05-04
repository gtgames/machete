class Media
  include MongoMapper::Document

  key :name,          String
  key :url,           String
  key :path,          String
  key :content_type,  String

  before_create :take_care

  def thumb(t=:default)
    if t.is_a? Symbol
      width = case t
        when :default
          '120x120'
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
        when :big
          '900xx600'
        else
          '120x120'
        end
    else
      width = "#{t}"
    end
    return self['url'].sub(/\.\w+$/, "_#{width}.#{self['ext']}")
  end

  private
  def take_care
    media_folder = "#{APP_ROOT}/public/media"
    subfolder = (/^image\/.*/.match(self['content_type']).nil?)? 'assets' : 'pictures'
    temp_path = self['path'] if self.new?
    self['name'] = self['name'].gsub(/\s+/,'_')
    self['url']  = (! self.new?)? self['url']  : "/media/#{subfolder}/#{self['_id']}/#{self['name']}"
    self['path'] = (! self.new?)? self['path'] : "#{media_folder}/#{subfolder}/#{self['_id']}/#{self['name']}"
    self['ext']  = (! self.new?)? self['ext']  : ::File.extname(self['name']).slice!(1..-1)

    if self.new?
      FileUtils.mkdir_p ::File.dirname(self['path'])
      FileUtils.cp temp_path, self['path']
    end
  end
end

