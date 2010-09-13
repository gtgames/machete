Frontend.controllers  do


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

  get :index, :map => "/sitemap", :provides => [:html, :json] do
    @pages = Pages.all(:order => [:title.desc])
    render 'sitemap/index'
  end


  ###############################################
  ## Pages                                      #
  ###############################################
  #get :index, :map => "/:lang/#{I18n.t 'routes.pages.index'}/" do
  get :index, :map => "/:lang/pages/" do
    render 'pages/index'
  end

  get :show, :map => "/:lang/:slug" do
    @page = Page.get_slug params[:slug]
    halt 404 if @page.nil?
    render 'pages/show'
  end

  get :text, :map => "/:lang/#{I18n.t 'routes.page_search.text'}" do
    @s = params[:q]
    if @s.nil? or ((@s.size < 4) | ( /[\w\s\d]+/i =~ @s ).nil?)
      render 'page_search/index'
    else
      @pages = Page.all( :title.like => "%#{@s}%" ) | Page.all( :text.like => "%#{@s}%" )
      render 'page_search/results'
    end
  end

  get :tags, :map => "/:lang/tag/:tags" do
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
  get :form, :map => "/contattaci" do
    render 'mail'
  end
  
  post :new, :map => "/contattaci" do
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

end