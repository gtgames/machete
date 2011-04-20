Machete.controllers :index do
  get :index, :map => '/' do
    render 'index/index'
  end
  
  get :sitemap, :provides => [:xml, :html] do
    @posts = Post.sort(:_id.desc).all
    @pages = Page.sort(:_id.desc).all
    render 'sitemap', :layout => false if content_type == :xml
    render 'sitemap'
  end
end