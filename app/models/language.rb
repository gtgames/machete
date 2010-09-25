class Language
  include DataMapper::Resource

  property :id,       Serial
  property :code,     String,   :required => true, :unique => true, :unique_index => true
  property :name,     String,   :required => true
  property :default,  Boolean,  :default => false

  # locale string like 'en-US' or 'en'
  validates_format_of :code, :with => /^[a-z]{2}(-[A-Z]{2})?$/


  def self.[](code)
    return nil if code.nil?
    first(:code => code.to_s.gsub('_', '-')) || first(:code => code.to_s)
  end
end