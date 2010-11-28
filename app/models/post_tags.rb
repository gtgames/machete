class PostTags < Sequel::Model
  many_to_many :posts
end