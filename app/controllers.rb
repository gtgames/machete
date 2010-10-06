Frontend.controllers do
  ###############################################
  ## Welcome                                    #
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
    @pages = Pages.all(:order => [:title.desc])
    render 'sitemap/index'
  end

  ###############################################
  ## Pages                                      #
  ###############################################
  get :pages, :map => "/pages/" do
    render 'pages/index'
  end

  get :page_show, :map => "/:id/:slug" do
    @page = Page.get params[:id]
    halt 404 if @page.nil?
    render 'pages/show'
  end

  get :page_search, :map => "/search" do
    @s = params[:q]
    if @s.nil? or ((@s.size < 4) | ( /[\w\s\d]+/i =~ @s ).nil?)
      render 'pages/search'
    else
      @pages = Page.all( :title.like => "%#{@s}%" ) | Page.all( :text.like => "%#{@s}%" )
      render 'page/results'
    end
  end

  get :page_tags, :map => "/tag/:tags" do
    @tags = params[:tags].split(',')
    @pages = Page.tagged_with(@tags)
    render 'page/tags'
  end

  ###############################################
  ## Contact us                                 #
  ###############################################
  get :contact_form, :map => "/contattaci" do
    render 'mail'
  end
  
  post :contact_new, :map => "/contattaci" do
    #params[:text] == //
    #params[:email] == /[a-z0-9!#\$\%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+(?:[A-Z]{2}|com|org|net|edu|gov|mil|biz|info|mobi|name|aero|asia|jobs|museum)\b/
    email do
      from params[:email]
      to "info@#{DOMAIN_NAME}"
      subject "[Nuovo messaggio] #{params[:title]}"
      body params[:text]
      via :sendmail
    end
  end

  ###############################################
  ## Media with a nice array of tags            #
  ###############################################

  get :media_index do
    @tags = Media.tags
    @media = Media.all
    render 'media/index'
  end

  get :media_show, :map => "/media/p/:id" do
    @media = Media.get params[:id]
    render 'media/show'
  end

  post :media_search, :map => "/media/search" do
    @media = Media.all :name.like => "%#{params[:term]}%"
    render 'media/index'
  end

  ###############################################
  ## Imagination                                #
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