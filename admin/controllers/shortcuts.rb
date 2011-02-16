# encoding: UTF-8
Admin.controllers :shortcuts do

  get :index do
    @shortcuts = Shortcut.all
    render 'shortcuts/index'
  end

  get :new do
    @shortcut = Shortcut.new
    render 'shortcuts/new'
  end

  post :create do
    @shortcut = Shortcut.new(params[:shortcut])
    if (@shortcut.save rescue false)
      flash[:notice] = t 'admin.create.success'
      redirect url(:shortcuts, :edit, :id => @shortcut.id)
    else
      render 'shortcuts/new'
    end
  end

  get :edit, :with => :id do
    @shortcut = Shortcut[params[:id]]
    render 'shortcuts/edit'
  end

  put :update, :with => :id do
    @shortcut = Shortcut[params[:id]]
    if @shortcut.modified! && @shortcut.update(params[:shortcut])
      flash[:notice] = t 'admin.update.success'
      redirect url(:shortcuts, :edit, :id => @shortcut.id)
    else
      render 'shortcuts/edit'
    end
  end

  delete :destroy, :with => :id do
    shortcut = Shortcut[params[:id]]
    if shortcut.destroy
      flash[:notice] = t 'admin.destroy.success'
    else
      flash[:error] = t 'admin.destroy.failure'
    end
    redirect url(:shortcuts, :index)
  end
end