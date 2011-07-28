require File.expand_path(File.dirname(__FILE__) + '/../../test_config.rb')

context "Frontend" do
  app Machete

  context "GET /" do
    setup { get "/" }

    if Cfg[:locales].size > 1
      asserts("the response status") { last_response.status }.equals 302
    else
      asserts("the response status") { last_response.status }.equals 200
    end
  end

  context "GET /:sitemap" do
    setup { get( (Cfg[:locales].size > 1 )? "/it/sitemap.html" : "/sitemap.html" ) }

    asserts("the response status") { last_response.status }.equals 200
    asserts("the content type") { last_response.headers["Content-Type"] }.equals "text/html;charset=utf-8"
  end

  context "GET /:sitemap.xml" do
    setup { get( (Cfg[:locales].size > 1 )? "/it/sitemap.xml" : "/sitemap.xml" ) }

    asserts("the response status") { last_response.status }.equals 200
    asserts("the content type") { last_response.headers["Content-Type"] }.equals "application/xml;charset=utf-8"
  end
end
