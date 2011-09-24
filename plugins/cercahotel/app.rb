class CercaHotel < BasicApplication
  layout Cfg.layout(:cercahotel)
end

CercaHotel.controllers do
  get :index do
    render 'index'
  end

  get :show, :with => :id do
    @hotel = Hotel.find(params[:id])
    render 'show'
  end

  get :search do
    if params[:q]
      @hotels = Hotel.where(params[:q])
      render 'search/results'
    else
      render 'search/form'
    end
  end
end