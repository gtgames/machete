class BookRequest
  include MongoMapper::Document
  set_collection_name 'bookings' # legacy updates

  key :name, String
  key :surname, String
  key :email, String
  key :city, String
  key :phone, String
  key :fax, String
  key :notes, String

  # Components
  key :adults, Integer, :default => 1
  key :children, Integer, :default => 0

  # Company
  key :business_name, String
  key :address, String
  key :vat, String
  key :snn, String

  # TimeDate
  key :date_arrival, Time, :default => lambda { Time.now.xmlschema }
  key :date_departure, Time, :default => lambda { Time.now.xmlschema }
  def date_arrival
    (self[:date_arrival].is_a? String)? self[:date_arrival] : self[:date_arrival].xmlschema
  end
  def date_departure
    (self[:date_departure].is_a? String)? self[:date_departure] : self[:date_departure].xmlschema
  end

  # various
  key :ip,  String
  key :ua,  String
  key :ref, String

  # state
  key :st, Integer, :default => 1 # 1  - unread state
                                  # 0  - read
                                  # -1 - deleted

  ## VALIDATIONS
  validates_presence_of :name, :surname, :email, :city
  validates_numericality_of :adults, :children
  validates_format_of :email, :with => /[\w\.]+@[\w\.]+\.\w+/

  ## HOOKS
  before_create :fill_meta
  private
  def fill_meta
    self.ip  = ENV['REMOTE_ADDR']
    self.ua  = ENV['HTTP_USER_AGENT']
    self.ref = ENV['HTTP_REFERER'] || '/'
  end
end
