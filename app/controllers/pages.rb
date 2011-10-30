Machete.controllers :pages do
  layout Cfg.layout('pages')

  get :index do
    @pages = Page.sort(:_id.desc).all
    etag @pages.last.updated_at.to_i
    render 'app/pages/index'
  end

  get :show, :map => "/page/:slug" do
    if !(@pages = Page.by_slug(params[:slug])).nil?
      etag @pages.updated_at.to_i
      render 'app/pages/show'
    else
      404
    end
  end

  get :taxonomy, :map => '/:taxon', :matching => [:taxon => /^[a-z0-9\-_\/]+$/], :priority => :low  do
    t = (params[:taxon].is_a? String)? params[:taxon] : params[:taxon].join('/')

    @taxonomy = Taxonomy.where(:"path.#{Cfg.locale}" => %r{#{t}}).first
    @pages = Page.by_taxonomy(t)

    if @pages.nil? or @taxonomy.nil?
      404
    else
      etag @pages.first.updated_at.to_i if @pages.size > 1

      size = @pages.size
      if size >= 1
        render 'app/pages/index'
      elsif size == 0
        render 'app/pages/index'
      end
    end
  end

end
