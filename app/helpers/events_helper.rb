Machete.helpers do
  def event_photos taglist
    if taglist.blank?
      []
    else
      Photos.where(:tags.in => taglist.split(', '))
    end
  end
end