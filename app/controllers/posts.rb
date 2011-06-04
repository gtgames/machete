Machete.controllers :posts, :lang => I18n.locale do
  get :index, :map => '/:lang/posts/' do
    @posts = Post.all
    render 'posts/index'
  end

  get :show, :map => '/:lang/posts/:slug' do
    if (@post = Post.find({:slug => params[:slug]}).first)
      render 'posts/show'
    else
      404
    end
  end
end
