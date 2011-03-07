# encoding:utf-8
Admin.helpers do
  def page_url_for(page)
    link_to( page.title, "http://#{DOMAIN_NAME}/#{page.id}/#{page.slug}")
  end
end