require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

context "Post Model" do
  setup { Post.delete_all }

  context 'can be created' do
    setup { Post.new }
    asserts("that record is not nil") { !topic.nil? }
  end
  context 'definition' do
    setup { Post.make }

    asserts_topic.has_key :title, String
    asserts_topic.has_key :slug,  String
    asserts_topic.has_key :lead,  String
    asserts_topic.has_key :text,  String
    asserts_topic.has_key :photo, MediaFile::Embeddable
    asserts_topic.has_key :tags,  Array


    asserts_topic.has_validation :validates_presence_of, :title
    asserts_topic.has_validation :validates_presence_of, :lead
    asserts_topic.has_validation :validates_presence_of, :text


    asserts_topic.has_validation :validates_uniqueness_of, :title
    asserts_topic.has_validation :validates_uniqueness_of, :slug

    asserts_topic.has_plugin MongoMachete::Taggable
  end
end
