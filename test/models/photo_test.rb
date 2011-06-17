require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

context "Photo Model" do
  setup { Photo.delete_all }

  context 'can be created' do
    setup { Photo.new }
    asserts("that record is not nil") { !topic.nil? }
  end

  context 'definition' do
    setup { Photo.make(:file => Sham.image) }

    asserts_topic.has_key :title,   String
    asserts_topic.has_key :file,    SimpleUploader

    asserts("that file has 'content_type'") { !topic.file['content_type'].nil? }
    asserts("that file has 'name'")         { !topic.file['name'].nil? }
    asserts("that file has 'path'")         { !topic.file['path'].nil? }
    asserts("that file has 'url'")          { !topic.file['url'].nil? }
    asserts("that can generate a thumb link") { topic.file.thumb(:small) }
  end
end
