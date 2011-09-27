Blog.helpers do
end

BasicApplication.helpers do
  def latest_posts n=5
    Post.where().limit(n).order(:created_at.desc) # pubished posts ordered by created_at
  end
end