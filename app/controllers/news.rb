Frontend.controllers :news do
  get :index do
    @news = Post.limit(10).all
    render 'news/index'
  end

  get :show, :with => [:id, :slug], :provides => [:any, :json]do
    @news = Post.first :id => params[:id], :slug => params[:slug]
    case content_type
    when :js then
      return @news.to_json
    else
      render 'news/index'
    end
  end

  get :page, :map => "/news/", :with => [:offset] do
    @news_count = Post.count()
    @news = Post.limit(10, params[:offset]*10).all # pagination
    render 'news/index'
  end

  get :year, :map => '/news/', :with => [:year] do
    @news = Post.filter("updated_at >= '#{Time.new(params[:year])}'").all
    render 'news/list'
  end

  get :month, :map => '/news/', :with => [:year, :month] do
    @news = Post.filter("updated_at >= '#{Time.new(params[:year], params[:month])}'").all
    render 'news/list'
  end

  get :day, :map => '/news/', :with => [:year, :month, :day] do
    @news = Post.filter("updated_at >= '#{Time.new(params[:year], params[:month], params[:day])}'").all
    render 'news/list'
  end
end