Machete.controllers :blog, :lang => I18n.locale do
  get :index, :map => '/:lang/blog/' do
    @posts = Post.all
    render 'blog/index'
  end

  get :show, :map => '/:lang/blog/:slug' do
    if (@post = Post.find({:slug => params[:slug]}).first)
      render 'blog/show'
    else
      404
    end
  end
end
