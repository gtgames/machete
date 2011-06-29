require "find"
require "fileutils"


# Imports site configuration from /config/config.json
task :import do
  json = JSON.parse File.read(Padrino.root('config', 'config.json'))

  json['site'].each_with_key do |v, k|
    c = Configuration.new :_id => k, :value => v
    c.save
  end
end


desc "Photo gallery mass import"
task :photo_import do
  gallery = ask('Nome Galleria:', :red)

  tags = ask('Lista tag (separati da virgola)').strip(' ').split(',')

  Dir.glob('./tmp/import/*').each do|f|
    say "processing: #{f}", :purple
    type =  case ::File.extname(f).slice!(1..-1)
            when /png$/i
              'image/png'
            when /jpe?g$/i
              'image/jpeg'
            else
              'image/image'
            end

    mf = MediaFile.create({
      :name => ::File.basename(f),
      :path => f,
      :content_type => type
    })

    Photo.create({
      :file => mf,
      :name => ::File.basename(f),
      :gallery => gallery,
      :tags => tags
    })
  end
end

desc "mass-import MediaFiles from ENV['ROOT']/tmp/mediafiles/"
task :massimport do
  Find.find(Padrino.root('tmp','mediafiles')).each{|f|
    if f.match(/\.(jpe?g|png|gif)$/i)
      p "Processing: #{f}"
      MediaFile.create({
        :name => ::File.basename(f),
        :path => f,
        :content_type => Wand.wave(f)
      })
    else
      p "!Skipping #{f}"
    end
  }
end
