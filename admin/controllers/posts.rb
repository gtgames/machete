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
    @post = Post.new(params[:post])
    if (@post.save rescue false)
      @post.tag_list params[:tags]
      flash[:notice] = 'Post was successfully created.'
      redirect url(:posts, :index)
    else
      render 'posts/new'
    end
  end

  get :edit, :with => :id do
    @post = Post[params[:id]]
    render 'posts/edit'
  end

  put :update, :with => :id do
    @post = Post[params[:id]]
    if @post.modified! && @post.update(params[:post])
      @post.tag_list params[:tags]
      flash[:notice] = 'Post was successfully updated.'
      redirect url(:posts, :index)
    else
      render 'posts/edit'
    end
  end

  delete :destroy, :with => :id do
    post = Post[params[:id]]
    if post.destroy
      flash[:notice] = 'Post was successfully destroyed.'
    else
      flash[:error] = 'Impossible destroy Post!'
    end
    redirect url(:posts, :index)
  end
end