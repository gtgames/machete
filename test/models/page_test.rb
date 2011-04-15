require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

context "Page" do

  setup { Page.delete_all }

  context "definition" do
    setup { Page.make }

    asserts_topic.has_key :title,       String, :required => true
    asserts_topic.has_key :slug,        String, :required => true
    asserts_topic.has_key :lead,        String, :required => true
    # associations
    asserts_topic.has_association :many, :posts, :foreign_key => :post_ids

    # validations
    asserts_topic.has_validation :validates_uniqueness_of,  :title
    asserts_topic.has_validation :validates_uniqueness_of,  :url
    asserts_topic.has_validation :validates_format_of,      :url, :with => /^[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix
  end
  
  context "grabs domain from url" do
    setup { Page.make :url => 'www.yahoo.com' }
    asserts(:domain).equals 'yahoo.com'
  end
end