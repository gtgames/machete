Machete.controllers :index do
  get :index, :map => '/' do
    render 'index/index'
  end

  get :youtube, :map => '/video' do
    pp Cfg['youtube']
    if ! Cfg[:youtube].nil?
      render 'index/youtube', :layout => Cfg.layout('video')
    else
      404
    end
  end

  get :sitemap, :provides => [:xml, :html] do
    @posts = Post.sort(:_id.desc).all
    @pages = Page.sort(:_id.desc).all
    render 'sitemap', :layout => false if content_type == :xml
    render 'sitemap', :layout => Cfg.layout('video')
  end
end
