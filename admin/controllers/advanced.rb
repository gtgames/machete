Admin.controllers :advanced do
  get :index do
    @title = Cfg[:title]
    render "admin/advanced/index"
  end
  put :update do
    render "admin/advanced/index"
  end
end
