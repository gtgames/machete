Shoppy.controllers :lang => I18n.locale do

  ###############################################
  ## Showcase                                   #
  ###############################################
  get :index, :map => "/:lang/" do
    @categories = (params[:c].nil?)? Category.all : Category.get(params[:c])
    render 'index'
  end

  get :category, :map => "/:lang/:id" do
    @category = Category.get(params[:id])
    render 'category'
  end

  get :show, :map => "/:lang/p/:id" do
    @product = Product.get(:id => params[:id])
    render 'product/show'
  end

  post :search, :map => "/:lang/search" do
    @products = Product.all(:name.like => "%#{params[:term]}%")
    render 'product/index'
  end

  ###############################################
  ## Cart                                       #
  ###############################################
  #TODO use redis for cart crap
  get :cart, :provides => [:any, :json], :map => "/:lang/cart/" do
    cookie = request.cookies["cart"]
    
    case content_type
    when :json then
      content_type :json
      @photos.to_json
    else
      render 'index'
    end
  end

  get :cart_product, :provides => [:any, :json], :map => "/:lang/cart/:id" do
    @product = Product.get(:id => params[:id])
    case content_type
    when :json then
      content_type :json
      @products.to_json
    else
      render 'product/show'
    end
  end

  post :cart_add, :provides => [:any, :json], :map => "/:lang/cart/" do
    cookie = request.cookies["cart"]
    case content_type
    when :json then
      content_type :json
      @products.to_json
    else
      render 'product/show'
    end
  end

end
