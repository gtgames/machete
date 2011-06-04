Admin.controllers :advanced do
  get :index do
    @title = Cfg[:title]
    render "advanced/index"
  end
  put :update do
    render "advanced/index"
  end
end
