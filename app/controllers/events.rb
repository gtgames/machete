Machete.controller :events do
  layout Cfg.layout(:events)

  get :index do
    @events = Event.where(:from.gt => Time.now ).sort(:from.lt)
    etag @events.last.id.generation_time.to_i

    render 'events/index'
  end

  get :archive do
    @event = Event.where(:from.lt => Time.now).sort(:from.gt)
    etag @events.first.id.generation_time.to_i

    render 'events/archive'
  end

  get :tag, :with => :tag do
    @event = Event.where(:tags.in => params[:tag].split(','))

    render 'events/archive'
  end
end
