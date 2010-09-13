Shoppy.controllers :index do

  get :index, :provides => [:any, :json] do
    @photos = Product.all
    case content_type
    when :json then
      content_type 'application/json'
      @photos.to_json
    else
      render 'index'
    end
  end

  get :show, :with => :id, :provides => [:any, :json] do
    @product = Product.get(:id => params[:id])
    case content_type
    when :json then
      content_type 'application/json'
      @products.to_json
    else
      render 'product/show'
    end
  end

  get :tag, :with => :tag, :provides => [:any, :json] do
    @products = Product.tagged_with params[:tag]
    case content_type
    when :json then
      content_type 'application/json'
      @products.to_json
    else
      render 'index'
    end
  end

  ###############################################
  ## Cart                                       #
  ###############################################
  #TODO use redis for cart crap
  get :index, :provides => [:any, :json] do
    @photos = Product.all
    case content_type
    when :json then
      content_type 'application/json'
      @photos.to_json
    else
      render 'index'
    end
  end

  get :get, :with => :id, :provides => [:any, :json] do
    @product = Product.get(:id => params[:id])
    case content_type
    when :json then
      content_type 'application/json'
      @products.to_json
    else
      render 'product/show'
    end
  end

  post :add, :provides => [:any, :json] do
    case content_type
    when :json then
      content_type 'application/json'
      @products.to_json
    else
      render 'product/show'
    end
  end

end
