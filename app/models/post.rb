class Post < Sequel::Model
  plugin :validation_helpers
  begin
    plugin :lazy_attributes, :text
  rescue
    # do nothing ... fking stupid bugs
  end

  def validate
    validates_length_range 3..100, :title
    validates_unique       :title
    validates_format       /[A-Za-z\s\w]*/, :title
  end

  def before_save
    self.text = html_cleanup(self.text)
    self.slug = "#{self.title}".to_slug
    super
  end
  def before_create
    self.created_at ||= Time.now
    super
  end
  def before_update
    self.updated_at ||= Time.now
    super
  end
end