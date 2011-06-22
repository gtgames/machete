require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

context "MediaFile Model" do
  setup { MediaFile.delete_all }

  context 'can be created' do
    setup { MediaFile.new }
    asserts("that record is not nil") { !topic.nil? }
  end

  context 'definition' do
    setup { MediaFile.make }

    asserts_topic.has_key :name, String
    asserts_topic.has_key :url, String
    asserts_topic.has_key :path, String
    asserts_topic.has_key :content_type, String


    asserts("that topic responds to 'file='") { !topic.respond_to?(:'file=').nil? }
    asserts("that topic responds to 'thumb'") { !topic.respond_to?(:thumb).nil? }

    asserts("that 'thumb' outputs an url") { topic.thumb() =~ %r{^/media/} }
  end
  context 'can be deleted' do
    setup { MediaFile.make }
    asserts("that record can be deleted") { !!topic.destroy }
    asserts("that file is being deleted") { !::File.file?(topic.path) }
  end
end
