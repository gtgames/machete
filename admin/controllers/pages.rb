Admin.controllers :pages do
  get :index do
    @pages = Page.sort(:_id.desc).all
    render 'pages/index'
  end

  get :new do
    @page = Page.new
    render 'pages/new'
  end

  post :create do
    @page = Page.new(params[:page])
    @page.taxonomy = params[:taxonomy].map { |t|
      Taxonomy.find(t)
    }

    if @page.save
      flash[:notice] = t'created'
      redirect url(:pages, :index)
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
    @page.taxonomy = params[:taxonomy].map { |t|
      Taxonomy.find(t)
    }

    if @page.update_attributes(params[:page])
      flash[:notice] = t'updated'
      redirect url(:pages, :edit, :id => @page.id)
    else
      render 'pages/edit'
    end
  end

  delete :destroy, :with => :id do
    page = Page.find(params[:id])
    if page.destroy
      flash[:notice] = t'destroy.success'
    else
      flash[:error] = t'destroy.fail'
    end
    redirect url(:pages, :index)
  end
end
