Admin.controllers :language do

  get :index do
    @languages = Language.all
    render 'languages/index'
  end

  get :new do
    @photo = Language.new
    render 'photos/new'
  end

  post :create do
    @photo = Photo.new(params[:photo])
    if @photo.save
      flash[:notice] = t 
      redirect url(:photos, :edit, :id => @photo.id)
    else
      render 'photos/new'
    end
  end

  get :edit, :with => :id do
    @photo = Photo.get(params[:id])
    render 'photos/edit'
  end

  put :update, :with => :id do
    @photo = Photo.get(params[:id])
    if @photo.update(params[:photo])
      flash[:notice] = 'Photo was successfully updated.'
      redirect url(:photos, :edit, :id => @photo.id)
    else
      render 'photos/edit'
    end
  end

  delete :destroy, :with => :id do
    image = Photo.get(params[:id])
    if image.destroy
      flash[:notice] = 'Photo was successfully destroyed.'
    else
      flash[:error] = 'Impossible destroy Photo!'
    end
    redirect url(:photos, :index)
  end
end
