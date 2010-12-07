class Tag < Sequel::Model
  one_to_many :taggings

  def validate
    super
    errors.add(:name, 'cannot be empty') if !name || name.empty?
  end
end
