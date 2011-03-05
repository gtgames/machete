Frontend.controllers :tags do
  get :index do
    redirect '/' if params[:t].nil?
    @posts = Post.tagged_with params[:t]
    @photos = Photo.tagged_with params[:t]
    @pages = Page.tagged_with params[:t]
    render 'tags/list'
  end

  get :json do
    content_type :json
    return DB[:tags].all.to_json
  end
end