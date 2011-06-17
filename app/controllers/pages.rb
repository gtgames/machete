Machete.controllers :pages, :lang => I18n.locale do

  get :index, :map => '/:lang/pages' do
    @pages = Page.sort(:_id.desc).all
    etag @pages.last.updated_at.to_i
    render 'pages/index'
  end

  get :show, :map => "/:lang/pages/:slug" do
    if (@page = Page.by_slug(params[:slug]))
      etag @page.updated_at.to_i
      render 'pages/show'
    else
      404
    end
  end

  get :taxon, :map => '/:lang/:taxon', :matching => [:id =>  %r{[\w\-_/]+}] do
    @pages = Page.by_taxonomy(params[:taxon]).all
    if (@pages.size > 0)
      if @pages.size == 1
        @pages = @pages.first
        render 'pages/show'
      else
        render 'pages/index'
      end
    else
      404
    end
  end

end
