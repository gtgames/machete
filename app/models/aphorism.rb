# encoding: utf-8
class Aphorism
  include DataMapper::Resource

  property :id,         Serial
  property :aphorism,   String, :required => true
  property :updated_at, DateTime
  property :created_at, DateTime

  def self.random
    n = all.count
    if n > 0
      all[rand(n)]
    else
      nil
    end
  end

end
