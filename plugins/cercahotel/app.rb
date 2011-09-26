class CercaHotel < BasicApplication
  set :views, Padrino.root('templates')

  layout Cfg.layout(:cercahotel)
end

CercaHotel.controllers do
  get :index do
    render 'cercahotel/index'
  end

  get :show, :with => :id do
    @hotel = Hotel.find(params[:id])
    render 'cercahotel/show'
  end

  get :search do
    if params[:q]
      @hotels = Hotel.where(params[:q])
      render 'cercahotel/search/results'
    else
      render 'cercahotel/search/form'
    end
  end
end