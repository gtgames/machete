Machete.controller :events do
  layout Cfg.layout(:events)

  get :index do
    @events = Event.sort(:from.gt)
    render 'events/index'
  end
  
  get :show, :with => :slug do
    @event = Event.find(:slug => params[:slug])
    render 'events/index'
  end
end
