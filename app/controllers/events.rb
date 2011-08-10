Machete.controller :events do
  layout Cfg.layout(:events)

  get :index do
    @events = Event.where(:to.gt => ( Time.now - 7.day )  ).sort(:from.lt)
    if @events.count == 0
      404
    else
      etag @events.last.id.generation_time.to_i unless @events.last.nil?
      render 'events/index'
    end
  end

  get :archive do
    @events = Event.sort(:from.gt)
    if @events.count == 0
      404
    else
      etag @events.first.id.generation_time.to_i unless @events.first.nil?
      render 'events/archive'
    end
  end

  get :tag, :with => :tag do
    @events = Event.where(:tags.in => params[:tag].split(','))
    if @events.count == 0
      404
    else
      render 'events/archive'
    end
  end
end
