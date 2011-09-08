Machete.controller :events do
  layout Cfg.layout(:events)

  get :index do
    if Event.count == 0
      404
    else
      @event = Event.where(:to.gt => ( Time.now )  ).sort(:from.lt).limit(1)

      if (@event.first.nil?)
        @event = Event.sort(:from.lt)

        @next = []
        @past = @event[1...-1]
        @event = @event.first
      else
        @next = @event[1...-1]
        @event = @event.first
        @past = Event.where(:to.lt => ( @event['to'] )  ).sort(:from.lt)
      end

      render 'events/index'
    end
  end

  get :show, :with => :slug do
    @events = Event.by_slug(params[:slug])
    if @events.count == 0
      404
    else
      render 'events/show'
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
