# encoding:utf-8
Admin.controllers :photos do

  get :index do
    @photos = Photo.all
    render 'photos/index'
  end

  get :new do
    @photo = Photo.new
    render 'photos/new'
  end

  post :create do
    @photo = Photo.new(params[:photo])
    if (@photo.save rescue false)
      flash[:notice] = t 'admin.create.success'
      redirect url(:photos, :edit, :id => @photo.id)
    else
      render 'photos/new'
    end
  end

  get :edit, :with => :id do
    @photo = Photo[params[:id]]
    render 'photos/edit'
  end

  put :update, :with => :id do
    @photo = Photo[params[:id]]
    if @photo.modified! && @photo.update(params[:photo])
      flash[:notice] = t 'admin.update.success'
      redirect url(:photos, :edit, :id => @photo.id)
    else
      render 'photos/edit'
    end
  end

  delete :destroy, :with => :id do
    photo = Photo[params[:id]]
    if photo.destroy
      flash[:notice] = t 'admin.destroy.success'
    else
      flash[:error] = t 'admin.destroy.failure'
    end
    redirect url(:photos, :index)
  end
end