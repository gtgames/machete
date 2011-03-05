Frontend.helpers do
  def aphorisms
    f = Aphorism.random
    unless f.nil?
      "#{f.aphorism}"
    else
      "..."
    end
  end

  def menu
    Menu.order(:weight).all
  end

  def tree(r = Page.roots)
    html = ''
    unless r.empty?
      html += "<ul>"
      r.each do |p|
        html += "<li>" + link_to(p.title, url(:pages_show, :id => p.id, :slug => "#{p.slug}" ))
        html += tree(p.children) unless p.children.empty?
        html << "</li>"
      end
      html << "</ul>"
    end
    html
  end

  def latest_news(limit = 10)
    Post.limit(limit).all
  end

  def shortcuts
    Shortcut.all
  end

  def tag_cloud
    html = ''
    DB[:tags].all.each do |t|
      html << link_to(t[:tag], url(:tags, :index, :t => t[:tag]), :class => "tag_#{t[:size]}")
    end
    return html
  end
end
