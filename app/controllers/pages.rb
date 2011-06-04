Machete.controllers :pages, :lang => I18n.locale do

  get :index, :map => '/:lang/pages' do
    @pages = Page.sort(:_id.desc).all
    etag @pages.last.updated_at.to_i
    render 'pages/index'
  end

  get :show, :map => '/:lang/:taxon', :matching => [:id => %r{[\w\-\_\/]+}] do
    @pages = Page.where(:tax => /#{params[:taxonomy]}/).all
    if (@pages.size > 0)
      render ((@pages.size == 1)? 'pages/show' : 'pages/index')
    else
      404
    end
  end
=begin
  get :taxonomy, :map => "/:lang/:taxonomy" do
    if (@pages = Page.where(:tax => /#{params[:taxonomy]}/).all)
      render 'pages/index'
    else
      404
    end
  end

  get :taxon, :map => "/:lang/:taxonomy/:taxon" do
    if (@pages = Page.where(:tax => /#{params[:taxonomy]}\/#{params[:taxon]}/).all)
      etag @pages.last.updated_at.to_i
      render 'pages/index'
    else
      404
    end
  end

  get :show, :map => "/:lang/:taxonomy/:taxon/:slug" do
    if (@page = Page.by_slug(params[:slug]))
      etag @page.updated_at.to_i
      render 'pages/show'
    else
      404
    end
  end
=end
end
