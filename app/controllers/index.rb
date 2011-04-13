Machete.controllers :index do

  get :index, :map => '/' do
    render 'index/index'
  end
  
  get :sitemap, :provides => [:xml, :html] do
    @posts = Post.find({}, {:sort => [:_id, :desc]})
    @pages = Page.find({}, {:sort => [:_id, :desc]})
    case content_type
      when :html then render 'sitemap'
      when :xml  then render :xml => @user.errors, :status => :unprocessable_entity
    end
  end
end