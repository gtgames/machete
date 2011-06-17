require File.expand_path(File.dirname(__FILE__) + '/../../test_config.rb')

context "Configuration Model" do
  context 'can be created' do
    setup { Configuration.new }
    asserts("that record is not nil") { !topic.nil? }
  end
end
