require 'pp'

Admin.controllers :pages do
  before do
    unless params[:page].nil?
      params[:page][:parent_id] = nil if params[:page][:parent_id] == '0'
      params[:page][:is_home_dir] = true if params[:page][:is_home_dir] == '1'
    end
  end

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
      redirect url(:pages, :edit, :id => @page.id)
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
      redirect url(:pages, :edit, :id => @page.id)
    else
      logger.error @page.errors.each{|e| e + '  |||  '}
      flash[:error] = t 'admin.create.failure'
      render 'pages/edit'
    end
  end

  delete :destroy, :with => :id do
    page = Page.get(params[:id])
    if page.translations.destroy! && page.destroy!
      flash[:notice] = t 'admin.destroy.success'
    else
      flash[:error] = t 'admin.create.failure'
      page.errors.each{|e| logger.error e}
    end
    redirect url(:pages, :index)
  end
end
