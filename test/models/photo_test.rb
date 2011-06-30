require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

context "Photo Model" do
  setup { Photo.delete_all }

  context 'can be created' do
    setup { Photo.new }
    asserts("that record is not nil") { !topic.nil? }
  end

  context 'definition' do
    setup {
      Photo.make(:file => MediaFile.make) }

    asserts_topic.has_key :title,   String
    asserts_topic.has_key :file,    MediaFile::Embeddable


    asserts("that file has 'name'")         { !topic.file['name'].nil? }
    asserts("that file has 'url'")          { !topic.file['url'].nil? }
    asserts("that can generate a thumb link") { topic.file.thumb(:small) }

    asserts("that file's 'content_type' can be retrieved") { !topic.file.content_type.nil? }
  end
  context 'definition' do
    setup { Photo.make(:gallery => 'Foo Bar', :file => MediaFile.make) }

    asserts("that :gallery_slug is generated") { topic.gallery_slug == 'foo-bar' }
  end
end

