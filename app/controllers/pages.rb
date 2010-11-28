Frontend.controllers :pages do

  get :pages, :map => "/pages/" do
    render 'pages/index'
  end

  get :page_show, :map => "/:id/:slug" do
    @page = Page.first :id => params[:id]
    halt 404 if @page.nil?
    render 'pages/show'
  end

  get :page_search, :map => "/search" do
    @s = params[:q]
    if @s.nil? or ((@s.size < 4) | ( /[\w\s\d]+/i =~ @s ).nil?)
      render 'pages/search'
    else
      @pages =  Page.full_text_search([:title, :text],@s)
      render 'page/results'
    end
  end

  get :page_tags, :map => "/tag/:tags" do
    @tags = params[:tags].split(',')
    @pages = Page.tagged_with(@tags)
    render 'page/tags'
  end

end