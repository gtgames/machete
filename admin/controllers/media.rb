Admin.controllers :dialogs do
  get :index do
    render 'dialogs/index'
  end
end

Admin.controllers :multimedia do
  get :index do
    render 'multimedia/index'
  end

  post :create do
    media = Media.new(params[:media])
    render 'multimedia/new'
  end
end
