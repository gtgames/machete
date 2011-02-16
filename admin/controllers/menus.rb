# encoding:utf-8
Admin.controllers :menus do
  get :index do
    @menus = Menu.order(:weight).all
    render 'menus/index'
  end

  get :new do
    @menu = Menu.new
    render 'menus/new'
  end

  post :create do
    @menu = Menu.new(params[:menu])
    if (@menu.save rescue false)
      flash[:notice] = t 'admin.create.success'
      redirect url(:menus, :edit, :id => @menu.id)
    else
      render 'menus/new'
    end
  end

  get :edit, :with => :id do
    @menu = Menu[params[:id]]
    render 'menus/edit'
  end

  put :update, :with => :id do
    @menu = Menu[params[:id]]
    if @menu.modified! && @menu.update(params[:menu])
      flash[:notice] = t 'admin.update.success'
      redirect url(:menus, :edit, :id => @menu.id)
    else
      render 'menus/edit'
    end
  end

  delete :destroy, :with => :id do
    menu = Menu[params[:id]]
    if menu.destroy
      flash[:notice] = t 'admin.destroy.success'
    else
      flash[:error] = t 'admin.destroy.failure'
    end
    redirect url(:menus, :index)
  end
end