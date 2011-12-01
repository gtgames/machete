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
    if params[:lat] and params[:lng]
      if params[:t].length
        @hotels = Hotel.by_location(params[:lat], params[:lng], {:type => params[:t]})
      else
        @hotels = Hotel.by_location(params[:lat], params[:lng])
      end
      render 'cercahotel/search_results'
    else
      render 'cercahotel/search'
    end
  end
end
