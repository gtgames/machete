require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

context "Account" do
  setup { Account.delete_all }

  context "definition" do
    setup { Account.make }
    asserts_topic.has_key :name,             String
    asserts_topic.has_key :surname,          String
    asserts_topic.has_key :email,            String
    asserts_topic.has_key :username,         String
    asserts_topic.has_key :crypted_password, String
    asserts_topic.has_key :role,             String

    # responds to
    asserts_topic.responds_to :password
    asserts_topic.responds_to :password_confirmation

    # validates presence of
    asserts_topic.has_validation :validates_presence_of, :email
    asserts_topic.has_validation :validates_presence_of, :username
    asserts_topic.has_validation :validates_presence_of, :role
    asserts_topic.has_validation :validates_presence_of, :password, :if => :password_required
    asserts_topic.has_validation :validates_presence_of, :password_confirmation, :if => :password_required

    # validates confirmation of
    asserts_topic.has_validation :validates_confirmation_of, :password, :if => :password_required

    # validates length of
    asserts_topic.has_validation :validates_length_of, :password, :within => 4..40, :if => :password_required
    asserts_topic.has_validation :validates_length_of, :email,    :within => 3..100
    asserts_topic.has_validation :validates_length_of, :username, :within => 3..100

    #validates uniqueness
    asserts_topic.has_validation :validates_uniqueness_of, :email, :case_sensitive => false
    asserts_topic.has_validation :validates_uniqueness_of, :username, :case_sensitive => false

    # validates format of
    asserts_topic.has_validation :validates_format_of, :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
    asserts_topic.has_validation :validates_format_of, :role, :with => /[A-Za-z]/
  end

  context "authenticate method" do
    setup { Account.make }
    asserts("passes with email")    { Account.authenticate(topic.email,'testest') }
    asserts("passes with username") { Account.authenticate(topic.username,'testest') }
    asserts("fails")  { Account.authenticate('bob@test.com','fail') }.nil
  end

  context "find_by_id method" do
    setup { Account.make }
    asserts("finds account") { Account.find_by_id(topic.id) }
  end
end
