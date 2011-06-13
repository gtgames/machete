Admin.helpers do
  def taxonomy_tree
    tax = Taxonomy.all
  end

  def tax_checked? id, list
    s = ''
    list.each { |t|
      s = 'checked="1"' if(t._id == id)
    }
    s
  end
end
