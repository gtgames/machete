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
    if (@aphorism.save rescue false)
      flash[:notice] = 'Aphorism was successfully created.'
      redirect url(:aphorisms, :edit, :id => @aphorism.id)
    else
      render 'aphorisms/new'
    end
  end

  get :edit, :with => :id do
    @aphorism = Aphorism[params[:id]]
    render 'aphorisms/edit'
  end

  put :update, :with => :id do
    @aphorism = Aphorism[params[:id]]
    if @aphorism.modified! && @aphorism.update(params[:aphorism])
      flash[:notice] = 'Aphorism was successfully updated.'
      redirect url(:aphorisms, :edit, :id => @aphorism.id)
    else
      render 'aphorisms/edit'
    end
  end

  delete :destroy, :with => :id do
    aphorism = Aphorism[params[:id]]
    if aphorism.destroy
      flash[:notice] = 'Aphorism was successfully destroyed.'
    else
      flash[:error] = 'Impossible destroy Aphorism!'
    end
    redirect url(:aphorisms, :index)
  end
end