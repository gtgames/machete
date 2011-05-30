
# Imports site configuration from /config/config.json
task :import do
  json = JSON.parse File.read(Padrino.root('config', 'config.json'))

  json['site'].each_with_key do |v, k|
    c = Configuration.new :key => k, :value => v
    c.save
  end
end
