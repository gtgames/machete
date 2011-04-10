class Account
  include MongoODM::Document
  attr_accessor :password, :password_confirmation
  self.include_root_in_json = false

  # Fields
  field :name,             String
  field :surname,          String
  field :email,            String
  field :crypted_password, String
  field :role,             String


  # Validations
  validates_presence_of     :email, :role
  validates_presence_of     :password,                   :if => :password_required
  validates_presence_of     :password_confirmation,      :if => :password_required
  validates_length_of       :password, :within => 4..40, :if => :password_required
  validates_confirmation_of :password,                   :if => :password_required
  validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :email,    :case_sensitive => false
  validates_format_of       :email,    :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates_format_of       :role,     :with => /[A-Za-z]/

  # Callbacks
  before_save :encrypt_password, :if => :password_required

  def id
    _id.to_s
  end

  ##
  # This method is for authentication purpose
  #
  def self.authenticate(email, password)
    account = find_one(:conditions => { :email => email }) if email.present?
    account && account.has_password?(password) ? account : nil
  end

  ##
  # This method is used by AuthenticationHelper
  #
  def self.find_by_id(id)
    find_one({_id:BSON::ObjectId(id)}) rescue nil
  end

  def has_password?(password)
    ::BCrypt::Password.new(crypted_password) == password
  end

  private
    def encrypt_password
      self.crypted_password = ::BCrypt::Password.create(self.password)
    end

    def password_required
      crypted_password.blank? || self.password.present?
    end
end
