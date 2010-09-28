Frontend.controllers :lang => I18n.locale do
  ###############################################
  ## Welcome                                    #
  ###############################################
  get :index, :map => "/:lang/" do
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
  get :pages, :map => "/:lang/#{I18n.t 'routes.pages.index'}/" do
    render 'pages/index'
  end

  get :page_show, :map => "/:lang/:slug" do
    @page = Page.get_slug params[:slug]
    halt 404 if @page.nil?
    render 'pages/show'
  end

  get :page_search, :map => "/:lang/#{I18n.t 'routes.page.search'}" do
    @s = params[:q]
    if @s.nil? or ((@s.size < 4) | ( /[\w\s\d]+/i =~ @s ).nil?)
      render 'page_search/index'
    else
      @pages = Page.all( :title.like => "%#{@s}%" ) | Page.all( :text.like => "%#{@s}%" )
      render 'page_search/results'
    end
  end

  get :page_tags, :map => "/:lang/tag/:tags" do
    @tags = params[:tags]
    if (/(\w+,?)+/i =~ @tags).nil?
      redirect url(:page_search, :text)
    end
    @s = params[:q]
    if @s.nil? or ((@s.size < 4) | ( /[\w\s\d]+/i =~ @s ).nil?)
      @pages = Page.tagged_with(@tags)
    else
      @pages = Page.tagged_with(@tags) | Page.all( :title.like => "%#{@s}%" ) | Page.all( :text.like => "%#{@s}%" )
    end
    render 'page_search/results'
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
  ## Shop                                       #
  ###############################################
  get :categories, :map => "/:lang/shop/" do
    @categories = (params[:c].nil?)? Category.all : Category.get(params[:c])
    render 'shop/index'
  end

  get :category, :map => "/:lang/shop/:id" do
    @category = Category.get(params[:id])
    render 'shop/category'
  end

  get :show, :map => "/:lang/shop/p/:id" do
    @product = Product.get(:id => params[:id])
    render 'shop/product/show'
  end

  post :search, :map => "/:lang/shop/search" do
    @products = Product.all(:name.like => "%#{params[:term]}%")
    render 'shop/product/index'
  end

  ###############################################
  ## Cart                                       #
  ###############################################
  #TODO use redis for cart crap
  get :cart, :provides => [:any, :json], :map => "/:lang/shop/cart/" do
    cookie = request.cookies["cart"]
    
    case content_type
    when :json then
      content_type :json
      @photos.to_json
    else
      render 'shop/cart/index'
    end
  end

  get :cart_product, :provides => [:any, :json], :map => "/:lang/shop/cart/:id" do
    @product = Product.get(:id => params[:id])
    case content_type
    when :json then
      content_type :json
      @products.to_json
    else
      render 'shop/product/show'
    end
  end

  post :cart_add, :provides => [:any, :json], :map => "/:lang/shop/cart/" do
    cookie = request.cookies["cart"]
    case content_type
    when :json then
      content_type :json
      @products.to_json
    else
      render 'shop/product/show'
    end
  end

end