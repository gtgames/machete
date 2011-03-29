Admin.controllers :base do
  get :index, :map => "/" do
    render "base/xhr", :layout => false
  end
end