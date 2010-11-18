Admin.controllers :media do

  get :index do
    @medias = Media.all
    render 'medias/index'
  end

  get :new do
    @media = Media.new
    render 'medias/new'
  end

  post :create do
    @media = Media.new(params[:media])
    if (@media.save rescue false)
      flash[:notice] = 'Media was successfully created.'
      redirect url(:media, :edit, :id => @media.id)
    else
      render 'medias/new'
    end
  end

  get :edit, :with => :id do
    @media = Media[params[:id]]
    render 'medias/edit'
  end

  put :update, :with => :id do
    @media = Media[params[:id]]
    if @media.modified! && @media.update(params[:media])
      flash[:notice] = 'Media was successfully updated.'
      redirect url(:media, :edit, :id => @media.id)
    else
      render 'medias/edit'
    end
  end

  delete :destroy, :with => :id do
    media = Media[params[:id]]
    if media.destroy
      flash[:notice] = 'Media was successfully destroyed.'
    else
      flash[:error] = 'Impossible destroy Media!'
    end
    redirect url(:media, :index)
  end
end