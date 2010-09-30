# encoding:utf-8
Admin.controllers :menus do
  get :index do
    @menus = Menu.all
    render 'menus/index'
  end

  get :new do
    @menu = Menu.new
    render 'menus/new'
  end

  post :create do
    @menu = Menu.new(params[:menu])
    if @menu.save
      flash[:notice] = t 'admin.create.success'
      redirect url(:menus, :index)
    else
      flash[:error] = t 'admin.create.failure'
      render 'menus/new'
    end
  end

  get :edit, :with => :id do
    @menu = Menu.get(params[:id])
    render 'menus/edit'
  end

  put :update, :with => :id do
    @menu = Menu.get(params[:id])
    if @menu.update(params[:menu])
      flash[:notice] = t 'admin.update.success'
      redirect url(:menus, :index)
    else
      flash[:error] = t 'admin.update.failure'
      render 'menus/edit'
    end
  end

  delete :destroy, :with => :id do
    menu = Menu.get(params[:id])
    if menu.translations.destroy! && menu.destroy!
      flash[:notice] = t 'admin.destroy.success'
    else
      flash[:error] = t 'admin.destroy.failure'
    end
    redirect url(:menus, :index)
  end
end
