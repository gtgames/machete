class Post < Sequel::Model
  def_dataset_method :full_text_search

  plugin :validation_helpers
  begin
    plugin :lazy_attributes, :text
  rescue
    # do nothing ... fking stupid bugs
  end
  plugin :taggable

  def validate
    super
    validates_length_range 3..255, :title
    validates_unique :title
    validates_format(/[A-Za-z\s\w]*/, :title)
  end

  def text=(param)
    super html_cleanup(param)
  end

  def before_save
    self.slug = "#{self.title}".to_slug
    super
  end
end