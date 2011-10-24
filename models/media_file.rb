module MediaFileThumber
  extend ActiveSupport::Concern
  module InstanceMethods
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
      return self.url.sub(/\.(\w+)$/, "_#{width}.#{self.url.match(/\.(\w+)$/)[1]}")
    end
  end
end

class MediaFile
  include MongoMapper::Document
  plugin MongoMapper::Plugins::Embeddable
  plugin MediaFileThumber

  key :name,          String
  key :url,           String
  key :path,          String
  key :content_type,  String
  key :ext,           String

  before_create :take_care
  after_destroy :handle_deletion

  embeds :name, :url

  private
  def take_care
    media_folder = Padrino.root('public', 'media')
    subfolder = (/^image\/.*/.match( self.content_type ).nil?)? 'assets' : 'pictures'
    temp_path = self.path if self.new?
    if self.new? && self.path.match(%r{#{ media_folder }}).nil?

      self.ext  = ::File.extname( self.name ).slice!( 1..-1 )
      self.name = self.name.gsub(/\%20/, ' ').to_slug.sub(/-[a-z]+$/, ".#{self.ext}")
      self.url  = "/media/#{ subfolder }/#{ self._id }/#{ self.name }"
      self.path = "#{ media_folder }/#{ subfolder }/#{ self._id }/#{ self.name }"


      FileUtils.mkdir_p ::File.dirname(self.path)
      FileUtils.cp temp_path, self.path
      # image conversion to max 900px x 600px
      `convert -resize 900x600 #{self.path}`
    end
  end
  def handle_deletion
    if ::File.file? self.path
      FileUtils.rm_rf self.path.sub(%r{#{self.name}$}, '')
    end
  end
end

class MediaFile::Embeddable
  plugin MediaFileThumber
end
