# encoding:utf-8
Admin.controllers :pages do
  get :index do
    @pages = Page.all
    render 'pages/index'
  end

  get :tree do
    render 'pages/tree'
  end

  get :new do
    @page = Page.new
    render 'pages/new'
  end

  post :create do
    @page = Page.new(params[:page])
    if @page.save
      flash[:notice] = t 'admin.create.success'
      redirect url(:pages, :index)
    else
      flash[:error] = t 'admin.create.failure'
      render 'pages/new'
    end
  end

  get :edit, :with => :id do
    @page = Page.get(params[:id])
    render 'pages/edit'
  end

  put :update, :with => :id do
    @page = Page.get(params[:id])
    if @page.update(params[:page])
      flash[:notice] = t 'admin.update.success'
      redirect url(:pages, :index)
    else
      flash[:error] = t 'admin.create.failure'
      render 'pages/edit'
    end
  end

  delete :destroy, :with => :id do
    page = Page.get(params[:id])

    #TODO: BUG!!!+ROTTURADICAZZO ###
    page.children.each do |p|
      p.parent = nil
      p.save!()
    end

    if page.translations.destroy && page.destroy!
      flash[:notice] = t 'admin.destroy.success'
    else
      flash[:error] = t 'admin.create.failure'
    end
    redirect url(:pages, :index)
  end
end
