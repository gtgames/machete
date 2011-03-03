Frontend.controllers :tags do
  get :index, :map => "/tags" do
    redirect '/' if params[:t].nil?
    @posts = Post.tagged_with params[:t]
    @photos = Photo.tagged_with params[:t]
    render 'tags/list'
  end
end