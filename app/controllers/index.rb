Machete.controllers :index do
  get :index do
    render 'index/index'
  end
  
  get :sitemap, :provides => [:xml, :html] do
    @posts = Post.find().asc(:updated_at)
    @pages = Page.find().asc(:updated_at)
    case content_type
      when :html then render 'sitemap'
      when :xml  then render :xml => @user.errors, :status => :unprocessable_entity
    end
  end
end