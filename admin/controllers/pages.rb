Admin.controllers :pages do
  provides :html, :json

  get :index do
    respond(@pages = Page.all)
  end

  get :new do
    respond(@page = Page.new)
  end

  post :create, :map => '/pages' do
    @page = Page.new(params[:page])
    @page.save
    respond @page, url(:pages, :edit, :id => @page.id)
  end

  get :edit, :with => :id, :map => '/pages' do
    respond(@page = Page.find(params[:id]))
  end

  put :update, :with => :id, :map => '/pages' do
    @page = Page.find(params[:id])
    @page.update_attributes(params[:page])
    respond(@page, url(:pages, :edit, :id => @page.id))
  end

  delete :destroy, :with => :id, :map => '/pages' do
    page = Page.find(params[:id])
    respond(page.destroy, url(:pages, :index))
  end
end