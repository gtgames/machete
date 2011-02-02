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


  get :resize, :with => :id do
    @media = Media[params[:id]]
    if (@media.type != 'image')
      flash[:error] = 'Errore, il documento non &nbsp; una immagine!'
      redirect url(:media, :index)
    end
    render 'medias/resize'
  end

  get :crop, :with => :id do
    @media = Media[params[:id]]
    if (@media.type != 'image')
      flash[:error] = 'Errore, il documento non &nbsp; una immagine!'
      redirect url(:media, :index)
    end
    render 'medias/crop'
  end

  post :process, :with => [:id, :action] do
    @media = Media[params[:id]]
    if params[:action] == "crop"
      if crop_image(@media.file.file.file, params[:w], params[:h], params[:x], params[:y])
        @media.file.recreate_versions!
        redirect url(:media, :index)
      else
        flash[:error] = 'Errore durante il rimpicciolimento dell\'immagine!'
      end
    else
      if resize_image(@media.file.file.file, params[:w], params[:h])
        @media.file.recreate_versions!
        redirect url(:media, :index)
      else
        flash[:error] = 'Errore durante il rimpicciolimento dell\'immagine!'
      end
    end
  end
end