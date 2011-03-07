# encoding:utf-8
Admin.helpers do
  def options_tree(my_id = nil, r = Page.roots)
    a = Array.new
    a << ['Radice', '0']
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
        if my_id != p.id
          a << ['•'*p.ancestors.size + "#{p.title}", p.id] unless my_id == p.id
          options_tree_array(my_id, p.children).each{|e|  a << e} unless p.children.empty?
        end
      end
    end
    return a
  end

  def tree(r = Page.roots)
    html = ''
    unless r.empty?
      html += "<ul>"
      r.each do |p|
        html += "<li id='#{p.id}'>#{p.title}"
        html += tree(p.children) unless p.children.empty?
        html += "</li>"
      end
      html += "</ul>"
    end
    return html
  end

  def to_tree(h, klass,i = 1)
    h.each{ |k,v|
      pid = k.split('-')
      eval(klass)[pid[0]].update({
        position: i,
        parent_id: (pid[1].to_i == 0)? nil : pid[1].to_i
      })
      if v.is_a? Hash
        to_tree(v, klass, i)
      end
      i += 1
    }
  end
end

