Machete.helpers do
  def photos_by_keywords(kwd, max=5)
    photos = Photo.where(:tags.in => kwd.to_s.split(',').map(&:downcase).uniq.map(&:strip)).limit(max).all

    if (count = photos.count) < max
      ids = photos.collect(&:_id)
      #db.photos.find({_id: {$nin: [ObjectId('4e65fa1efb28ef03540000c0'), ObjectId('4e65fa6efb28ef086200002d')] } })
      Photo.where(:_id => {:$nin => ids } ).limit(max - count).each{|p| photos << p }
    end

    photos
  end
  def photos_by_gallery(gallery)
    Photo.where(:gallery_slug => gallery)
  end
end
