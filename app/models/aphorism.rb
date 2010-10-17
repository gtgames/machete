class Aphorism < Sequel::Model
  plugin :validation_helpers

  def validate
    validates_length_range 3..100, :aphorism
    validates_unique       :aphorism
    validates_format       /[A-Za-z\s\w]*/, :aphorism
  end

  def self.random
    with_sql("SELECT * FROM \"#{table_name}\" ORDER BY RANDOM() LIMIT 1").first
  end
end
