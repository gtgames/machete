Admin.controllers :pages do

  get :index do
    @pages = Page.all
    render 'pages/index'
  end

  get :new do
    @page = Page.new
    render 'pages/new'
  end

  post :create do
    @page = Page.new(params[:page])
    if @page.save
      flash[:notice] = 'Page was successfully created.'
      redirect url(:pages, :edit, :id => @page.id)
    else
      render 'pages/new'
    end
  end

  get :edit, :with => :id do
    @page = Page.find(params[:id])
    render 'pages/edit'
  end

  put :update, :with => :id do
    @page = Page.find(params[:id])
    if @page.update_attributes(params[:page])
      if params[:page][:parent] != @page.parent._id
        @page.parent = (params[:page][:parent].empty?)? nil : Page.find(params[:page][:parent])
      end

      flash[:notice] = 'Page was successfully updated.'
      redirect url(:pages, :edit, :id => @page.id)
    else
      render 'pages/edit'
    end
  end

  delete :destroy, :with => :id do
    page = Page.find(params[:id])
    if page.destroy
      flash[:notice] = 'Page was successfully destroyed.'
    else
      flash[:error] = 'Impossible destroy Page!'
    end
    redirect url(:pages, :index)
  end
end