# encoding:utf-8
Admin.helpers do

  def options_tree(my_id = nil, r = Page.roots)
    a = Array.new
    a << ['Radice', 'NULL']
    unless r.empty?
      r.each do |p|
        if my_id != p.id
          a << ['•'*p.ancestors.size + " #{p.title}", p.id]
          options_tree_array(my_id, p.children).each{|e| a << e} unless p.children.empty?
        end
      end
    end
    return a
  end

  def options_tree_array(my_id = nil, r = Page.roots)
    a = Array.new
    unless r.empty?
      r.each do |p|
        a << ['•'*p.ancestors.size + "#{p.title}", p.id] unless my_id == p.id
        options_tree_array(my_id, p.children).each{|e|  a << e} unless p.children.empty?
      end
    end
    return a
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

