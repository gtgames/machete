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

  def latest_news
    Post.limit(10).all
  end

  def shortcuts
    Shortcut.all
  end
end
