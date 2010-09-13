class Language
  include DataMapper::Resource

  property :id, Serial

  property :code, String, :required => true, :unique => true, :unique_index => true
  property :name, String, :required => true

  # locale string like 'en-US' or 'en'
  validates_format :code, :with => /^[a-z]{2}(-[A-Z]{2})?$/


  def self.[](code)
    return nil if code.nil?
    first :code => code.to_s.gsub('_', '-')
  end
end