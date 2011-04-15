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
    if @photo.save
      flash[:notice] = 'Photo was successfully created.'
      redirect url(:photos, :edit, :id => @photo.id)
    else
      render 'photos/new'
    end
  end

  get :edit, :with => :id do
    @photo = Photo.find(params[:id])
    render 'photos/edit'
  end

  put :update, :with => :id do
    @photo = Photo.find(params[:id])
    if @photo.update_attributes(params[:photo])
      flash[:notice] = 'Photo was successfully updated.'
      redirect url(:photos, :edit, :id => @photo.id)
    else
      render 'photos/edit'
    end
  end

  delete :destroy, :with => :id do
    photo = Photo.find(params[:id])
    if photo.destroy
      flash[:notice] = 'Photo was successfully destroyed.'
    else
      flash[:error] = 'Impossible destroy Photo!'
    end
    redirect url(:photos, :index)
  end
end