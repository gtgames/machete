Admin.controllers :posts do

  get :index do
    @posts = Post.all
    render '/blog/admin/index'
  end

  get :new do
    @post = Post.new
    render '/blog/admin/new'
  end

  post :create do
    params[:post]['photo'] = MediaFile.find(params[:post]['photo'])
    @post = Post.new(params[:post])
    if @post.save
      flash[:info] = t'created'
      redirect url(:posts, :index)
    else
      render '/blog/admin/new'
    end
  end

  get :edit, :with => :id do
    @post = Post.find(params[:id])
    render '/blog/admin/edit'
  end

  put :update, :with => :id do
    params[:post]['photo'] = MediaFile.find(params[:post]['photo']) if !params[:post]['photo'].nil?
    @post = Post.find(params[:id])
    if @post.update_attributes(params[:post])
      flash[:info] = 'Post was successfully updated.'
      redirect url(:posts, :index)
    else
      render '/blog/admin/edit'
    end
  end

  delete :destroy, :with => :id do
    post = Post.find(params[:id])
    if post.destroy
      flash[:info] = t'destroy.success'

      (request.xhr?)? 200 : redirect(url(:posts, :index))
    else
      flash[:error] = t'destroy.fail'

      (request.xhr?)? 500 : redirect(url(:posts, :index))
    end
  end
end
