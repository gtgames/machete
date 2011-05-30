Admin.controllers :pages do
  get :index do
    @pages = Page.all
    render 'pages/index'
  end

  get :new do
    @page = Page.new
    @page.title = Translated.new
    @page.lead = Translated.new
    @page.text = Translated.new
    render 'pages/new'
  end

  post :create do
    @page = Page.new(params[:page])
    if @page.save
      if @page.parent.nil? or params[:page][:parent] != @page.parent._id
        @page.parent = Page.find(params[:page][:parent]) unless params[:page][:parent].empty?
      end

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
      flash[:notice] = 'Page was successfully updated.'
      redirect url(:pages, :edit, :id => @page.id)
    else
      render 'pages/edit'
    end
  end

  delete :destroy, :with => :id do
    page = Page.find(params[:id])
    if page.destroy
      flash[:notice] = t 'destroy.success'
    else
      flash[:error] = t 'destroy.fail'
    end
    redirect url(:pages, :index)
  end

  # TODO: unified interface with index
  get :tree do
    @pages = Page.roots
    render 'pages/tree'
  end
end
