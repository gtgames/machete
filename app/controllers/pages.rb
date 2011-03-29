Machete.controllers :pages do

  get :index do
    @pages = Page.all
    render 'pages/index'
  end

  get :index, :map => "/:slug" do
    @page = Page.where(:slug => params[:slug]).first
    render 'pages/show'
  end

end