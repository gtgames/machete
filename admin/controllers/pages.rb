# encoding:utf-8
Admin.controllers :pages do
  get :index do
    @pages = Page.all
    render 'pages/index'
  end

  get :tree do
    puts tree()
    render 'pages/tree'
  end

  post :tree do
    to_tree(JSON.parse(params[:page][:serialized]), "Page")
    render 'pages/tree'
  end

  get :new do
    @page = Page.new
    render 'pages/new'
  end

  post :create do
    @page = Page.new(params[:page])
    if (@page.save rescue false)
      flash[:notice] = t 'admin.create.success'
      redirect url(:pages, :edit, :id => @page.id)
    else
      render 'pages/new'
    end
  end

  get :edit, :with => :id do
    @page = Page[params[:id]]
    render 'pages/edit'
  end

  put :update, :with => :id do
    @page = Page[params[:id]]
    if @page.modified! && @page.update(params[:page])
      flash[:notice] = t 'admin.update.success'
      redirect url(:pages, :edit, :id => @page.id)
    else
      render 'pages/edit'
    end
  end

  delete :destroy, :with => :id do
    page = Page[params[:id]]
    if page.remove_all_attachments && page.destroy
      flash[:notice] = t 'admin.destroy.success'
    else
      flash[:error] = t 'admin.destroy.failure'
    end
    redirect url(:pages, :index)
  end
end