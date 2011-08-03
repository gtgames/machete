Machete.helpers do
  def event_photos taglist
    Photos.where(:tags.in => taglist.split(', '))
  end
end