# encoding:utf-8
Admin.helpers do

  def options_tree(my_id = nil, r = Page.roots)
    a = Array.new
    a << ['Radice', '0']
    unless r.empty? or p.id == my_id
      r.each do |p|
        a << ['•'*p.ancestors.size + "#{p.title}", p.id]
        options_tree(my_id, p.children) unless p.children.empty?
      end
    end
    a
  end


  def tree(r = Page.roots)
    html = ''
    unless r.empty?
      html += "<ul>"
      r.each do |p|
        html += "<li>#{p.title} &nbsp;"
        html += button_to pat(:edit), url(:pages, :edit, :id => p.id), :method => :get, :class => :button_to
        html += button_to pat(:delete), url(:pages, :destroy, :id => p.id), :method => :delete, :class => :button_to
        html += tree(p.children) unless p.children.empty?
        html << "</li>"
      end
      html << "</ul>"
    end
    logger.debug "HTML: #{html}"
    return html
  end

  def page_url_for(page)
    html = ''
    options.locales.each do |l|
      html += link_to( page.title(l), "#{options.frontend_url}/#{l}/#{page.slug(l)}")
    end
    html
  end
end

