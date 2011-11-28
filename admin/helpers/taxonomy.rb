#encoding: utf-8
Admin.helpers do
  def taxonomy_tree
    tax = Taxonomy.all
  end

  def tax_checked? id, list
    l = false
    list.each do |t|
       l = true if(t._id.to_s == id.to_s)
    end
    l
  end
end
