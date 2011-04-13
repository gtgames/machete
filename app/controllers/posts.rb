Machete.controllers :posts do

  get :index do
    @posts = Post.all
    render 'posts/index'
  end

  get :index, :with => [:slug] do
    @post = Post.find_one({:slug => params[:slug]}).first
    render 'posts/show'
  end

end