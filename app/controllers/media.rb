Frontend.controllers :media do
  get :index do
    @media = Media.all
    render 'media/index'
  end

  get :show, :map => "/media/p/:id" do
    @media = Media.first :id => params[:id]
    render 'media/show'
  end

  post :search, :map => "/media/search" do
    @media = Media.full_text_search([:name],params[:term])
    render 'media/index'
  end
end