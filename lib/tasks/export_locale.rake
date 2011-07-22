# usage:
# bundle exec rake locale:file RAILS_ENV=production
# if you want to export a different locale (not en.yml), provide locale option, as follows:
# bundle exec rake locale:file RAILS_ENV=production locale=ru

def write_to_database(path, value)
  key = path.join('.')
  @store[key] = value.gsub(/\\"/, '')
end

# traverse through hash
def traverse(obj, path)
  case obj
  when Hash
    obj.each do |k,v|
      traverse(v, path + [k])
    end
  when Array
    obj.each {|v| traverse(v) }
  else # end values
    write_to_database(path, obj)
  end
end

namespace :locale do
  desc <<-eos
    Exports $app/config/locale/$locale.yml contents to mongodb database.
    If locale is not specified, default (en) locale file will be exported.
  eos
  task :read_files do
    @store = MongoI18n::Store.new(I18NDB['strings'])

    (Dir[File.join(Padrino.root, "app/**", '*.yml')] | Dir[File.join(Padrino.root, "admin/**", '*.yml')]).each do |f|
      p f
      dump = YAML::load(File.open(f))
      traverse(dump, [])
    end
  end
end
