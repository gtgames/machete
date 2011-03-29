require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

context "PagesController" do
  context "description here" do
    setup do
      get "/"
    end

    asserts("the response body") { last_response.body }.equals "Hello World"
  end
end
