Admin.controllers :cerca_hotel do

  get :index do
    @hotels = Hotel.all
    render 'cercahotel/admin/index'
  end

  get :new do
    @hotel = Hotel.new
    render 'cercahotel/admin/new'
  end

  post :create do
    @hotel = Hotel.new(params[:account])
    if @hotel.save
      flash[:notice] = t'created'
      redirect url(:accounts, :index)
    else
      render 'cercahotel/admin/new'
    end
  end

  get :edit, :with => :id do
    @hotel = Hotel.find(params[:id])
    render 'cercahotel/admin/edit'
  end

  put :update, :with => :id do
    @hotel = Hotel.find(params[:id])
    if @hotel.update_attributes(params[:account])
      flash[:notice] = t'updated'
      redirect url(:accounts, :index)
    else
      render 'cercahotel/admin/edit'
    end
  end

  delete :destroy, :with => :id do
    hotel = Hotel.find(params[:id])
    if hotel != current_account && account.destroy
      flash[:notice] = t'destroy.success'
    else
      flash[:error] = t'destroy.fail'
    end
    redirect url(:cerca_hotel, :index)
  end
end