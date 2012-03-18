#
# Machete Plugins
#
# TODO: Make something cleaner
def PluginManager plugs
  plugs.each do |plugin|
    begin
      unless File.directory?( "#{PADRINO_ROOT}/templates/#{plugin}" )

        if File.directory?("#{PADRINO_ROOT}/plugins/#{plugin}/templates/#{plugin}")
          puts "Linking #{plugin} templates"
          File.symlink("#{PADRINO_ROOT}/plugins/#{plugin}/templates/#{plugin}", "#{PADRINO_ROOT}/templates/#{plugin}")
        end

        if File.directory?("#{PADRINO_ROOT}/plugins/#{plugin}/mailers/#{plugin}")
          puts "Linking #{plugin} mailers"
          File.symlink(
            "#{PADRINO_ROOT}/plugins/#{plugin}/templates/mailers/#{plugin}", "#{PADRINO_ROOT}/templates/mailers/#{plugin}")
        end
      end
    rescue Errno::EEXIST
      # do nothing
    end
    Padrino.set_load_paths(
      "#{PADRINO_ROOT}/plugins/#{plugin}", "#{PADRINO_ROOT}/plugins/#{plugin}/models")

    require "#{PADRINO_ROOT}/plugins/#{plugin}/app"
    Dir.glob("#{PADRINO_ROOT}/plugins/#{plugin}/models/*.rb").each{|r|
      require r.sub(/\.rb$/, '') }
  end



  Cfg['apps'].each do |app, mountpoint|
    begin
      Object.const_get(app) # testing app existance

      puts "Mounting App: #{app}..."
      Padrino.mount("#{app}").to("#{mountpoint.downcase}").host(/^(?!(admin|www\.admin)).*$/)
    rescue NameError
      # do nothing
      logger.error "not mounting #{app}"
    end
  end unless Cfg['apps'].nil?
end
###