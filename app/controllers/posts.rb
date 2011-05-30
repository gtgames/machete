Machete.controllers :posts, :lang => I18n.locale do
  get :index, :map => '/:lang/posts/' do
    @posts = Post.all
    render 'posts/index'
  end

  get :show, :with => [:slug], :map => '/:lang/posts' do
    @post = Post.find({:slug => params[:slug]}).first
    render 'posts/show'
  end
end
