require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

context "Configuration Model" do
  setup { Configuration.delete_all }
  context 'can be created' do
    setup { Configuration.new }
    asserts("that record is not nil") { !topic.nil? }
  end

  context "definition" do
    setup { Configuration.make }

    asserts("that _id is a String") { topic._id.class == String }
    asserts("that value is an Object") { !topic.val.nil? }
  end

  context "JSON parsing" do
    setup {
      Configuration.delete_all
      Configuration.make :val => '{"foo":"bar"}' }

    asserts("that value is JSON Parsed") { topic.val["foo"] == "bar" }
  end
end
