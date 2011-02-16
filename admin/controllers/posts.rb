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
      flash[:notice] = t 'admin.create.success'
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
      flash[:notice] = t 'admin.update.success'
      redirect url(:posts, :index)
    else
      render 'posts/edit'
    end
  end

  delete :destroy, :with => :id do
    post = Post[params[:id]]
    if post.destroy
      flash[:notice] = t 'admin.destroy.success'
    else
      flash[:error] = t 'admin.destroy.failure'
    end
    redirect url(:posts, :index)
  end
end