Machete.helpers do
  def photos_by_keywords(kwd, max=5)
    Photo.where(:tags.in => kwd.to_s.split(',').map(&:downcase).uniq.map(&:strip)).limit(max)
  end
  def photos_by_gallery(gallery)
    Photo.where(:gallery_slug => gallery)
  end
end
