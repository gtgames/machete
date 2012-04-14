xml.instruct!
xml.urlset "xmlns"=> "http://www.google.com/schemas/sitemap/0.9" do
  xml.url do
    xml.loc "http://#{Cfg[:domain]}/"
    xml.lastmod Time.now.utc.strftime("%Y-%m-%dT%H:%M:%S+00:00")
    xml.changefreq "daily"
    xml.priority 0.9
  end
  if defined?Blog
    @posts.each do |post|
      xml.url do
        xml.loc "http://#{Cfg[:domain]}#{Blog.url(:show, :slug => post.slug)}"
        xml.lastmod post.updated_at.utc.strftime("%Y-%m-%dT%H:%M:%S+00:00")
        xml.changefreq "daily"
        xml.priority 0.5
      end
    end
  end
  @pages.each do |page|
    xml.url do
      xml.loc "http://#{Cfg[:domain]}#{url(:pages, :show, :slug => page.slug[Cfg.locale])}"
      xml.lastmod page.updated_at.utc.strftime("%Y-%m-%dT%H:%M:%S+00:00")
      xml.changefreq "weekly"
      xml.priority 0.4
    end
  end
  @taxonomies.each do |taxon|
    xml.url do
      xml.loc "http://#{Cfg[:domain]}/#{taxon.path[Cfg.locale]}"
      xml.lastmod taxon.updated_at.utc.strftime("%Y-%m-%dT%H:%M:%S+00:00")
      xml.changefreq "weekly"
      xml.priority 0.6
    end
  end
end
