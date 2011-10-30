Machete.controllers :index do
  get :index, :map => '/' do
    render '/app/index/index', :layout => Cfg.layout('index')
  end

  get :youtube, :map => '/video' do
    if not Cfg[:youtube].nil?
      render '/app/index/youtube', :layout => Cfg.layout('video')
    else
      404
    end
  end

  get :sitemap, :provides => [:xml, :html], :map => '/sitemap' do
    @posts = (defined?(Post))? Post.sort(:_id.desc) : []
    @pages = Page.sort(:_id.desc)
    @taxonomies = Taxonomy.sort(:path.asc)
    render 'sitemap', :layout => false if content_type == :xml
    render 'sitemap'
  end
end
