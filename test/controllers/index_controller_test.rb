require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

context "IndexController" do
  context "index response" do
    setup do
      get "/"
    end

    asserts("the response status") { last_response.status }.equals 200
  end

  context "html sitemap response" do
    setup do
      get "/sitemap.html"
    end
    asserts("the response status") { last_response.status }.equals 200
    asserts("the content type") { last_response.headers["Content-Type"] }.equals "text/html;charset=utf-8"
  end

  context "xml sitemap response" do
    setup do
      get "/sitemap.xml"
    end
    asserts("the response status") { last_response.status }.equals 200
    asserts("the content type") { last_response.headers["Content-Type"] }.equals "application/xml;charset=utf-8"
  end
end
