# encoding:utf-8
Admin.controllers :aphorisms do

  get :index do
    @aphorisms = Aphorism.all
    render 'aphorisms/index'
  end

  get :new do
    @aphorism = Aphorism.new
    render 'aphorisms/new'
  end

  post :create do
    @aphorism = Aphorism.new(params[:aphorism])
    if @aphorism.save
      flash[:notice] = t 'admin.create.success'
      redirect url(:aphorisms, :index)
    else
      flash[:notice] = t 'admin.create.failure'
      render 'aphorisms/new'
    end
  end

  get :edit, :with => :id do
    @aphorism = Aphorism.get(params[:id])
    render 'aphorisms/edit'
  end

  put :update, :with => :id do
    @aphorism = Aphorism.get(params[:id])
    if @aphorism.update(params[:aphorism])
      flash[:notice] = t 'admin.update.success'
      redirect url(:aphorisms, :index)
    else
      flash[:notice] = t 'admin.update.failure'
      render 'aphorisms/edit'
    end
  end

  delete :destroy, :with => :id do
    aphorism = Aphorism.get(params[:id])
    if aphorism.destroy
      flash[:notice] = t 'admin.destroy.success'
    else
      flash[:error] = t 'admin.destroy.failure'
    end
    redirect url(:aphorisms, :index)
  end
end
