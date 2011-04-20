Machete.controllers :posts do
  get :index do
    @posts = Post.all
    render 'posts/index'
  end

  get :show, :with => [:slug], :map => '/posts' do
    @post = Post.find({:slug => params[:slug]}).first
    render 'posts/show'
  end
end