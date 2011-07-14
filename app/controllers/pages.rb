Machete.controllers :pages do

  get :index do
    @pages = Page.sort(:_id.desc).all
    etag @pages.last.updated_at.to_i
    render 'pages/index', :layout => Cfg.layout('pages')
  end

  get :show, :map => "/page/:slug" do
    if !(@pages = Page.by_slug(params[:slug])).nil?
      etag @pages.updated_at.to_i
      render 'pages/show', :layout => Cfg.layout('pages')
    else
      404
    end
  end

  get :taxonomy, :map => '/:taxon', :matching => [:taxon => /^[a-z0-9\-_\/]+$/], :priority => :low  do
    @taxonomy = Taxonomy.where(:"path.#{Cfg.locale}" => %r{#{params[:taxon]}}).first
    @pages = Page.by_taxonomy(params[:taxon]).all
    if @pages.size == 1
      @pages = @pages.first
      render 'pages/show', :layout => Cfg.layout('pages')
    else
      render 'pages/index', :layout => Cfg.layout('pages')
    end
  end

end
