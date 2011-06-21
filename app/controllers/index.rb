Machete.controllers :index, :lang => I18n.locale do
  get :index, :map => '/:lang/' do
    render 'index/index'
  end

  get :youtube, :map => '/:lang/video' do
    pp Cfg['youtube']
    if ! Cfg[:youtube].nil?
      render 'index/youtube'
    else
      404
    end
  end

  get :sitemap, :provides => [:xml, :html], :map => '/:lang/sitemap' do
    @posts = Post.sort(:_id.desc).all
    @pages = Page.sort(:_id.desc).all
    render 'sitemap', :layout => false if content_type == :xml
    render 'sitemap'
  end
end
