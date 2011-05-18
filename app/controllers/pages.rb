Machete.controllers :pages do
  get :index do
    @pages = Page.sort(:_id.desc).all
    etag @pages.last.updated_at.to_i
    render 'pages/index'
  end

  get :show, :map => "/:slug" do
    if (@page = Page.first({:slug => params[:slug].downcase}))
      render 'pages/show'
    else
      404
    end
  end
end
