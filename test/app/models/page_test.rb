require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

context "Page" do

  setup { Page.delete_all }

  context "definition" do
    setup { Page.make }

    asserts_topic.has_key :title,   Translation
    asserts_topic.has_key :slug,    Translation
    asserts_topic.has_key :lead,    Translation
    asserts_topic.has_key :text,    Translation

    asserts_topic.has_key :position,          Integer
    asserts_topic.has_key :meta_keyword
    asserts_topic.has_key :meta_description
    asserts_topic.has_key :browser_title

    asserts_topic.has_association :many, :taxonomy

    # validations
    asserts_topic.has_validation :validates_presence_of,  :title
    asserts_topic.has_validation :validates_presence_of,  :lead
    asserts_topic.has_validation :validates_presence_of,  :text

    # Plugins
    asserts_topic.has_plugin MongoMapper::Plugins::HashParameterAttributes

  end

end
