require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

context "Page" do

  setup { Page.delete_all }

  context "definition" do
    setup { Page.make }

    asserts_topic.has_key :title,   String
    asserts_topic.has_key :slug,    String
    asserts_topic.has_key :lead,    String
    asserts_topic.has_key :text,    String
    asserts_topic.has_key :tags,    Array

    # validations
    asserts_topic.has_validation :validates_presence_of,  :title
    asserts_topic.has_validation :validates_presence_of,  :lead
    asserts_topic.has_validation :validates_uniqueness_of,  :title
    asserts_topic.has_validation :validates_uniqueness_of,  :slug
  end
  
  context "slug is equal to title.to_slug" do
    setup { Page.make :title => 'foo bar' }
    asserts(:slug).equals 'foo-bar'
  end
end