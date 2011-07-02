Machete.controllers :blog do
  get :index do
    @posts = Post.all
    render 'blog/index'
  end

  get :show, :map => '/blog/:slug' do
    if (@post = Post.find({:slug => params[:slug]}).first)
      render 'blog/show'
    else
      404
    end
  end
end
