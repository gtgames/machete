Gallery.helpers do
  def photos_by_gallery(gallery)
    Photo.where(:gallery_slug => gallery)
  end
end

BasicApplication.helpers do
  def photos_by_keywords(kwd, max=5, fill=false)
    photos = Photo.where(:tags.in => kwd.to_s.split(',').map(&:downcase).uniq.map(&:strip)).limit(max).all

    if fill and (count = photos.count) < max
      ids = photos.collect(&:_id)
      Photo.where(:_id => {:$nin => ids } ).limit(max - count).each{|p| photos << p }
    end

    photos
  end

  def latest_photos n=5
    Photo.where().order(:_id.desc).limit(n)
  end
end
