class Media < Sequel::Model
  def_dataset_method :full_text_search

  # hooks
  def before_create
    self.created_at ||= Time.now
    super
  end
  def before_update
    self.updated_at = Time.now
    super
  end
end
