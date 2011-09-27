Events.helpers do
end

BasicApplication.helpers do
  def events_upcoming
    Event.where(:to.gt => ( Time.now )  ).sort(:from.asc)
  end
end