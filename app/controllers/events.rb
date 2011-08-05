Machete.controller :events do
  layout Cfg.layout(:events)

  get :index do
    @events = Event.where(:from.gt => Time.now ).sort(:from.lt)
    unless @events.count > 0
      404
    end
    etag @events.last.id.generation_time.to_i

    render 'events/index'
  end

  get :archive do
    @events = Event.where(:from.lt => Time.now).sort(:from.gt)
    unless @events.count > 0
      404
    end
    etag @events.first.id.generation_time.to_i

    render 'events/archive'
  end

  get :tag, :with => :tag do
    @events = Event.where(:tags.in => params[:tag].split(','))
    unless @events.count > 0
      404
    end

    render 'events/archive'
  end
end
