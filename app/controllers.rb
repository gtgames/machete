Frontend.controllers do
  ###############################################
  #  Welcome                                    #
  ###############################################
  get :index, :map => "/" do
    @page = Page.home_page
    unless @page.nil?
      render 'pages/show'
    else
      render 'index'
    end
  end

  get :sitemap, :map => "/sitemap", :provides => [:html, :json] do
    @pages = Pages.order(:title).all
    render 'sitemap/index'
  end

  ###############################################
  #  Pages                                      #
  ###############################################
  get :news_index, :map => "/news/" do
    @news = Post.limit(10).all
    render 'news/index'
  end

  get :news_show, :map => "/news/:id/:slug" do
    @news = Post.first :id => params[:id], :slug => params[:slug]
    render 'news/index'
  end

  get :news_page, :map => "/news/page/:offset" do
    @news = Post.limit(10, params[:offset]*10).all # pagination
    render 'news/index'
  end

  get :news_year, :map => '/news/', :with => [:year] do
    @news = Post.filter("updated_at >= #{Time.new(params[:year])}").all
    render 'news/index'
  end

  get :news_month, :map => '/news/', :with => [:year, :month] do
    @news = Post.filter("updated_at >= #{Time.new(params[:year], params[:month])}").all
    render 'news/index'
  end

  get :news_day, :map => '/news/', :with => [:year, :month, :day] do
    @news = Post.filter("updated_at >= #{Time.new(params[:year], params[:month], params[:day])}").all
    render 'news/index'
  end


  ###############################################
  #  Pages                                      #
  ###############################################
  get :pages, :map => "/pages/" do
    render 'pages/index'
  end

  get :page_show, :map => "/:id/:slug" do
    @page = Page.first :id => params[:id]
    halt 404 if @page.nil?
    render 'pages/show'
  end

  get :page_search, :map => "/search" do
    @s = params[:q]
    if @s.nil? or ((@s.size < 4) | ( /[\w\s\d]+/i =~ @s ).nil?)
      render 'pages/search'
    else
      @pages =  Page.full_text_search([:title, :text],@s)
      render 'page/results'
    end
  end

  get :page_tags, :map => "/tag/:tags" do
    @tags = params[:tags].split(',')
    @pages = Page.tagged_with(@tags)
    render 'page/tags'
  end

  ###############################################
  #  Contact us                                 #
  ###############################################
  get :contact_form, :map => "/contattaci/" do
    @mail  = Contact.new
    render 'mailers/index'
  end
  post :contact_new, :map => "/contattaci/" do
    @mail = Contact.new params[:mail]

    if @mail.valid? && @mail.classification != 'spam' && (@mail.save rescue false)
      deliver(:mailer, :info, @mail.author, @mail.email, Sanitize.clean(@mail.text))
      flash[:info] = I18n.t 'contact.ok'
      render 'mailers/index'
    else
      flash[:error] = I18n.t 'contact.error'
      render 'mailers/index'
    end
  end

  ###############################################
  #  Media with a nice array of tags            #
  ###############################################

  get :media_index, :map => "/media/" do
    @tags = Media.tags
    @media = Media.all
    render 'media/index'
  end

  get :media_show, :map => "/media/p/:id" do
    @media = Media.first :id => params[:id]
    render 'media/show'
  end

  post :media_search, :map => "/media/search" do
    @media = Media.full_text_search([:name],params[:term])
    render 'media/index'
  end

  ###############################################
  #  Imagination                                #
  ###############################################
  get :imagination_index, :map => "/imagination/", :provides => [:any, :json] do
    @photos = Photo.all
    case content_type
    when :json then
      content_type 'application/json'
      @photos.to_json
    else
      render 'imagination/index', :layout => false
    end
  end

  get :imagination_tag, :map => "/imagination/:tag", :provides => [:any, :json] do
    @photos = Photo.tagged_with params[:tag]
    case content_type
    when :js then
      content_type 'application/json'
      @photos.to_json
    else
      render 'imagination/index', :layout => false
    end
  end

end
