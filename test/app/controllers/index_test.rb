require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

context "Frontend" do
  app Machete

  context "GET /" do
    setup { get "/" }

    asserts("the response status") { last_response.status }.equals 302
  end


  context "GET /:lang/" do
    setup { get "/it/" }

    asserts("the response status") { last_response.status }.equals 200
  end

  context "GET /it/:sitemap" do
    setup { get "/it/sitemap.html" }
    asserts("the response status") { last_response.status }.equals 200
    asserts("the content type") { last_response.headers["Content-Type"] }.equals "text/html;charset=utf-8"
  end

  context "GET /it/:sitemap.xml" do
    setup { get "/it/sitemap.xml" }
    asserts("the response status") { last_response.status }.equals 200
    asserts("the content type") { last_response.headers["Content-Type"] }.equals "application/xml;charset=utf-8"
  end
end
