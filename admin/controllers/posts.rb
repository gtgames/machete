Admin.controllers :posts do

  get :index do
    @posts = Post.all
    render 'posts/index'
  end

  get :new do
    @post = Post.new
    render 'posts/new'
  end

  post :create do
    params[:post]['photo'] = MediaFile.find(params[:post]['photo'])
    @post = Post.new(params[:post])
    if @post.save
      flash[:notice] = t'created'
      redirect url(:posts, :index)
    else
      render 'posts/new'
    end
  end

  get :edit, :with => :id do
    @post = Post.find(params[:id])
    render 'posts/edit'
  end

  put :update, :with => :id do
    params[:post]['photo'] = MediaFile.find(params[:post]['photo']) if !params[:post]['photo'].nil?
    @post = Post.find(params[:id])
    if @post.update_attributes(params[:post])
      flash[:notice] = 'Post was successfully updated.'
      redirect url(:posts, :index)
    else
      render 'posts/edit'
    end
  end

  delete :destroy, :with => :id do
    post = Post.find(params[:id])
    if post.destroy
      flash[:notice] = 'Post was successfully destroyed.'
    else
      flash[:error] = 'Impossible destroy Post!'
    end
    redirect url(:posts, :index)
  end
end
