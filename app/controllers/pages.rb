Machete.controllers :pages do
  get :index do
    @pages = Page.sort(:_id.desc).all
    etag @pages.last.updated_at.to_i
    render 'pages/index'
  end

  get :show, :map => "/:slug" do
    @page = Page.find({:slug => params[:slug]}).first
    render 'pages/show'
  end
end