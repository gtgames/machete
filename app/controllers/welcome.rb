Frontend.controllers :welcome do
  get :index, :map => "/" do
    @page = Page.home_page
    unless @page.nil?
      render 'pages/show'
    else
      render 'index'
    end
  end

  get :sitemap, :map => "/sitemap", :provides => [:html, :json] do
    @pages = Pages.order(:title).all
    render 'sitemap/index'
  end
end