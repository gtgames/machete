class Tagging < Sequel::Model
  plugin :polymorphic
  many_to_one :tag
  many_to_one :taggable, :polymorphic => true
  
  def validate
    super
    errors.add(:tag_id, 'cannot be empty') if !tag_id
    errors.add(:taggable_id, 'cannot be empty') if !taggable_id
    errors.add(:taggable_type, 'cannot be empty') if !taggable_type || taggable_type.empty?
  end

#  def taggable
#    eval("#{taggable_type}.get!(#{taggable_id})") if taggable_type and taggable_id
#  end
end
