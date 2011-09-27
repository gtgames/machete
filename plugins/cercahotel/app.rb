class CercaHotel < BasicApplication
  set :views, Padrino.root('templates')

  layout Cfg.layout(:cercahotel)
end

CercaHotel.controllers do
  get :index do
    @hotels = Hotel.paginate({
      :order    => :created_at.asc,
      :per_page => 15, 
      :page     => params[:p] || 0,
    })
    render 'cercahotel/index'
  end

  get :show, :with => :slug do
    @hotel = Hotel.where(:slug => params[:slug]).first
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