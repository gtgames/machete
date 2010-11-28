class Post < Sequel::Model
  def_dataset_method :full_text_search

  plugin :validation_helpers
  plugin :timestamps, :create=>:created_on, :update=>:updated_on
  begin
    plugin :lazy_attributes, :text
  rescue
    # do nothing ... fking stupid bugs
  end

  many_to_many :post_tags

  def tagged_with=(tag_list)
    tag_list.scan(/[\w]+/).each do |t|
      tag = PostTag.find_or_create(:name => t)
      self.add_tag tag
    end
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
    super
  end
end