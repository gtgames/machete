Machete.helpers do
  def menu
    Link.all
  end

  alias_method :url_alias, :url
  def url *args
    if Cfg['locales'].size > 1
      '/' + Cfg.locale + url_alias(*args)
    else
      url_alias(*args)
    end
  end
end
BasicApplication.helpers do
  def h text
    Rack::Utils.escape_html text
  end
  
  def lazy_img(thumb, options={}, href=nil)
    o = {
        w: '', h: '', title: ''
    }
    o.merge(options)
    i  = '<img class="lazy" data-src="' << thumb << '" alt="' << o[:title] << '">'
    ii = '<img src="' << thumb << '" alt="' << o[:title] << '">'
    if href
      '<a href="' << href << '">' << i << '</a>' << '<noscript><a href="' << href << '">' << ii << '</a></noscript>'
    else
      i << '<noscript>' << ii << '</noscript>'
    end
  end
  
  def lazy_thumb(file, w, h, title = '')
    lazy_img file.thumb("#{w}x#{h}"), {w: w, h: h, title: title}, file.thumb(:big)
  end
end