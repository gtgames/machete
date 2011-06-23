require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

context "Message Model" do
  setup { Message.delete_all }
  context 'can be created' do
    setup { Message.new }
    asserts("that record is not nil") { !topic.nil? }
  end

  context "definition" do
    setup { Message.make }

    asserts_topic.has_key :author,  String
    asserts_topic.has_key :email,   String
    asserts_topic.has_key :phone,  String
    asserts_topic.has_key :text,   String

    asserts_topic.has_key :ip,  String
    asserts_topic.has_key :ua,   String
    asserts_topic.has_key :ref,   String

    asserts('that respond to :comment_author') { topic.respond_to? :"comment_author" }
    asserts('that respond to :comment_author_email') { topic.respond_to? :"comment_author_email" }
    asserts('that respond to :comment_content') { topic.respond_to? :"comment_content" }
    asserts('that respond to :user_ip') { topic.respond_to? :"is_spam" }
    asserts('that respond to :user_agent') { topic.respond_to? :"is_spam" }
    asserts('that respond to :referrer') { topic.respond_to? :"is_spam" }
    asserts('that respond to :is_spam') { topic.respond_to? :"is_spam" }

  end
end
