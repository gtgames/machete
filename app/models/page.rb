class Page < Sequel::Model
  def_dataset_method :full_text_search
  #default ordering
  set_dataset dataset.order(:title)
  # Recursive adjacency list
  plugin :rcte_tree
  plugin :validation_helpers
  begin
    plugin :lazy_attributes, :text
  rescue
    # do nothing ... fking stupid bugs
  end
  plugin :taggable

  one_to_many :attachments

  def is_home=t
    Page.where.filter({:is_home => true} & ~{:id => self.id}).update(:is_home => false) if t == '1' or t == true
    super
  end

  def validate
    super
    validates_length_range 3..100, :title
    validates_unique :title
    validates_format(/[A-Za-z\s\w]*/, :title)
  end

  def before_save
    self.text = html_cleanup(self.text)
    self.slug = "#{self.title}".to_slug
    self.parent_id = (self.parent_id == 0)? nil : self.parent_id
    super
  end

  def before_destroy
    self.children.each do |c|
      c.update(:parent => self.parent)
    end
  end

  def roots
    self.all(:parent_id => nil)
  end
  
  def self.home_page
    first(:is_home => true)
  end

end
=begin
  ## http://sequel.rubyforge.org/rdoc-plugins/classes/Sequel/Plugins/RcteTree.html

  Model.plugin :rcte_tree

  # Lazy loading
  model = Model.first
  model.parent
  model.children
  model.ancestors # Populates :parent association for all ancestors
  model.descendants # Populates :children association for all descendants

  # Eager loading - also populates the :parent and children associations
  # for all ancestors and descendants
  Model.filter(:id=>[1, 2]).eager(:ancestors, :descendants).all

  # Eager loading children and grand children
  Model.filter(:id=>[1, 2]).eager(:descendants=>2).all
  # Eager loading children, grand children, and great grand children
  Model.filter(:id=>[1, 2]).eager(:descendants=>3).all
=end