Machete.controllers :pages do

  get :index do
    @pages = Page.find({}, {:sort => [:_id, :desc]})
    etag @pages.last
    render 'pages/index'
  end

  get :index, :map => "/:slug" do
    @page = Page.find_one({:slug => params[:slug]})
    render 'pages/show'
  end

end