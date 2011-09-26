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
    @hotel = Hotel.new(params[:hotel])
    if @hotel.save
      flash[:notice] = t'created'
      redirect url(:cerca_hotel, :index)
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
    if @hotel.update_attributes(params[:hotel])
      flash[:notice] = t'updated'
      redirect url(:cerca_hotel, :index)
    else
      render 'cercahotel/admin/edit'
    end
  end

  delete :destroy, :with => :id do
    hotel = Hotel.find(params[:id])
    if hotel.destroy
      flash[:notice] = t'destroy.success'
    else
      flash[:error] = t'destroy.fail'
    end
    redirect url(:cerca_hotel, :index)
  end
end