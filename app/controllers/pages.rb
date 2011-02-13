Frontend.controllers :pages do

  get :index do
    render 'pages/index'
  end

  get :show, :map => "/:id/:slug", :id => /\d+/ do
    begin
      @page = Page.first :id => params[:id]
    rescue Sequel::DatabaseError
      halt 404
    end
    render 'pages/show'
  end

  get :search, :map => "/search" do
    @s = params[:q]
    if @s.nil? or ((@s.size < 4) | ( /[\w\s\d]+/i =~ @s ).nil?)
      render 'pages/search'
    else
      @pages =  Page.full_text_search([:title, :text],@s)
      render 'page/results'
    end
  end
end
