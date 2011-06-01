Machete.controllers :pages, :lang => I18n.locale do
  get :index, :map => '/:lang/pages' do
    @pages = Page.sort(:_id.desc).all
    etag @pages.last.updated_at.to_i
    render 'pages/index'
  end

  get :show, :map => "/:lang/:slug" do
    if (@page = Page.by_slug(params[:slug]).first)
      render 'pages/show'
    else
      404
    end
  end
end
