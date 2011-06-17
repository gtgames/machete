require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

context "Link Model" do
  setup { Link.delete_all }

  context 'can be created' do
    setup { Link.new }

    asserts("that record is not nil") { !topic.nil? }
  end

  context "definition" do
    setup { Link.make }

    asserts_topic.has_key :title,   Translation
    asserts_topic.has_key :url,    Translation

    asserts_topic.has_plugin MongoMapper::Plugins::HashParameterAttributes
  end
end
