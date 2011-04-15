Machete.controllers :pages do

  get :index do
    @pages = Page.find({}, {:sort => [:_id, :desc]})
    etag @pages.last.updated_at.to_i
    render 'pages/index'
  end

  get :index, :map => "/:slug" do
    @page = Page.find({:slug => params[:slug]}).first
    render 'pages/show'
  end

end