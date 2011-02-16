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
    @partner = Partner.new(params[:partner])
    if (@partner.save rescue false)
      flash[:notice] = t 'admin.create.success'
      redirect url(:partner, :edit, :id => @partner.id)
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
    if @partner.modified! && @partner.update(params[:partner])
      flash[:notice] = t 'admin.update.success'
      redirect url(:partner, :edit, :id => @partner.id)
    else
      render 'partners/edit'
    end
  end

  delete :destroy, :with => :id do
    media = Partner[params[:id]]
    if Partner.destroy
      flash[:notice] = t 'admin.destroy.success'
    else
      flash[:error] = t 'admin.destroy.failure'
    end
    redirect url(:partner, :index)
  end


  get :resize, :with => :id do
    @partner = Partner[params[:id]]
    if (@partner.type != 'image')
      flash[:error] = 'Errore, il documento non &nbsp; una immagine!'
      redirect url(:partner, :index)
    end
    render 'partners/resize'
  end

  get :crop, :with => :id do
    @partner = Partner[params[:id]]
    if (@partner.type != 'image')
      flash[:error] = 'Errore, il documento non &nbsp; una immagine!'
      redirect url(:partner, :index)
    end
    render 'partners/crop'
  end
end