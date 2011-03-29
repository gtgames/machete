Admin.controllers :links do
  provides :html, :json

  get :index do
    respond(@links = Link.all)
  end

  get :new do
    respond(@link = Link.new)
  end

  post :create, :map => '/links' do
    @link = Link.new(params[:link])
    @link.save
    respond(@link, url(:links, :edit, :id => @link.id))
  end

  get :edit, :with => :id do
    respond(@link = Link.find(params[:id]))
  end

  put :update, :with => :id do
    @link = Link.find(params[:id])
    respond(@link.update_attributes(params[:link]), url(:links, :edit, :id => params[:id]))
  end

  delete :destroy, :with => :id do
    link = Link.find(params[:id])
    respond(link.destroy ,url(:links, :index))
  end
end