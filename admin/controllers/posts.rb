Admin.controllers :posts do
  provides :html, :json

  get :index do
    respond(@posts = Post.all)
  end

  get :new do
    respond(@post = Post.new)
  end

  post :create, :map => '/posts' do
    @post = Post.new(params[:post])
    @post.save
    respond(@post, url(:posts, :edit, :id => @post.id))
  end

  get :edit, :with => :id, :map => '/posts' do
    respond(@post = Post.find(params[:id]))
  end

  put :update, :with => :id, :map => '/posts' do
    @post = Post.find(params[:id])
    @post.update_attributes(params[:post])
    respond(@post, url(:posts, :edit, :id => @post.id))
  end

  delete :destroy, :with => :id, :map => '/posts' do
    post = Post.find(params[:id])
    respond(post.destroy, url(:posts, :index))
  end
end