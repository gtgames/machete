Frontend.controllers :pages do

  get :index do
    render 'pages/index'
  end

  get :show, :map => "/:id/:slug", :id => /\d+/ do
    @page = Page.filter(:id => params[:id]).first
    
    halt 404 if @pahe.nil?
    
    render 'pages/show'
  end

  get :search, :map => "/search" do
    @s = params[:q].gsub(/\s/, ' & ')
    if @s.nil? or ((@s.size < 4) | ( /[\w\s\d]+/i =~ @s ).nil?)
      render 'pages/search'
    else
      @pages =  Page.full_text_search([:title, :text],@s)
      render 'page/results'
    end
  end
end
