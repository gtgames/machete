class Booking
  include MongoMapper::Document

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
  key :date_arrival, Date, :default => lambda { Time.now.strftime("%Y-%m-%d %H:%M") }
  key :date_departure, Date, :default => lambda { Time.now.strftime("%Y-%m-%d %H:%M") }

  # various
  key :ip,  String
  key :ua,  String
  key :ref, String

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
