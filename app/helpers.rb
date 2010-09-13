Frontend.helpers do
  def locale
    I18n.locale
  end

  def fortune
    f = Fortune.random
    unless f.nil?
      "#{f.get_fortune}"
    else
      "Non esiste alcun aforisma"
    end
  end

  def menu
    Menu.all :order => [:weigth.asc]
  end

  def tree(r = Page.roots)
    html = ''
    unless r.empty?
      html += "<ul>"
      r.each do |p|
        html += "<li><a href='#{ url(:pages, :show, :id => p.id, :slug => p.slug) }'>#{p.title}</a>"
        html += tree(p.children) unless p.children.empty?
        html << "</li>"
      end
      html << "</ul>"
    end
    html
  end

  def textilize(text)
    RDiscount.new(text).to_html
  end

end
