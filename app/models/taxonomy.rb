class Taxonomy
  include MongoMapper::Document

  key :slug, Translation
  key :title, Translation
end
