Machete.helpers do
  def event_photos taglist
    taglist = taglist.split(', ')
    if taglist.size == 0
      []
    else
      Photo.where(:tags.in => taglist)
    end
  end
end