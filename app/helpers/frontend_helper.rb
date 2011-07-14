Machete.helpers do
  def menu
    Link.all
  end

  alias_method :url_alias, :url
  def url *args
    if Cfg['locales'].size > 1
      Cfg.locale + url_alias(*args)
    else
      url_alias(*args)
    end
  end
end
