xml.instruct!
xml.urlset "xmlns"=> "http://www.google.com/schemas/sitemap/0.9" do
 @posts.each do |post|
  xml.url do
   xml.loc "http://#{Cfg[:domain]}/#{url(:posts, :show, :slug => post.slug)}"
   xml.lastmod Time.now.utc.strftime("%Y-%m-%dT%H:%M:%S+00:00")
   xml.changefreq "daily"
   xml.priority 0.8
  end
 end
end
