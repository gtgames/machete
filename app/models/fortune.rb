# encoding: utf-8

class Fortune
  include DataMapper::Resource

  property :id, Serial
  property :fortune, String
  property :updated_at, DateTime
  property :created_at, DateTime

  def self.get_random
    n = all.count
    if n > 0
      all[rand(n)]
    else
      nil
    end
  end

end
