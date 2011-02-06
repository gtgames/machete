Admin.controllers :partner do

  get :index do
    @partners = Partner.all
    render 'partners/index'
  end

  get :new do
    @partner = Partner.new
    render 'partners/new'
  end

  post :create do
    @partner = Partner.new(params[:media])
    if (@partner.save rescue false)
      flash[:notice] = 'Partner was successfully created.'
      redirect url(:media, :edit, :id => @partner.id)
    else
      render 'partners/new'
    end
  end

  get :edit, :with => :id do
    @partner = Partner[params[:id]]
    render 'partners/edit'
  end

  put :update, :with => :id do
    @partner = Partner[params[:id]]
    if @partner.modified! && @partner.update(params[:media])
      flash[:notice] = 'Partner was successfully updated.'
      redirect url(:media, :edit, :id => @partner.id)
    else
      render 'partners/edit'
    end
  end

  delete :destroy, :with => :id do
    media = Partner[params[:id]]
    if Partner.destroy
      flash[:notice] = 'Partner was successfully destroyed.'
    else
      flash[:error] = 'Impossible destroy Partner!'
    end
    redirect url(:partner, :index)
  end


  get :resize, :with => :id do
    @partner = Partner[params[:id]]
    if (@partner.type != 'image')
      flash[:error] = 'Errore, il documento non &nbsp; una immagine!'
      redirect url(:media, :index)
    end
    render 'partners/resize'
  end

  get :crop, :with => :id do
    @partner = Partner[params[:id]]
    if (@partner.type != 'image')
      flash[:error] = 'Errore, il documento non &nbsp; una immagine!'
      redirect url(:media, :index)
    end
    render 'partners/crop'
  end

  post :process, :with => [:id, :action] do
    @partner = Partner[params[:id]]
    if params[:action] == "crop"
      if crop_image(@partner.file.file.file, params[:w], params[:h], params[:x], params[:y])
        @partner.file.recreate_versions!
        redirect url(:media, :index)
      else
        flash[:error] = 'Errore durante il rimpicciolimento dell\'immagine!'
      end
    else
      if resize_image(@partner.file.file.file, params[:w], params[:h])
        @partner.file.recreate_versions!
        redirect url(:media, :index)
      else
        flash[:error] = 'Errore durante il rimpicciolimento dell\'immagine!'
      end
    end
  end
end