Admin.helpers do
  def taxonomy_tree
    tax = Taxonomy.all
  end

  def tax_checked? id, list
    s = ''
    list.each { |t|
      s = 'checked' if(t._id.to_s == id)
    }
    s
  end
end
