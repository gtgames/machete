Admin.controllers :shop do

  get :index do
    render "shop/index"
  end

#########################################################################
# Categories                                                            #
#########################################################################

  get :categories do
    @categories = Category.all
    render "shop/categories/index"
  end

  get :new_category do
    @category = Category.new
    render "shop/categories/new"
  end

  post :create_category do
    @category = Category.new(params[:category])
    if @category.save
      flash[:notice] = t 'admin.create.success'
      redirect url(:shop, :categories)
    else
      flash[:error] = t 'admin.create.failure'
      render "shop/categories/new"
    end
  end

  get :edit_category, :with => :id do
    @category = Category.get(params[:id])
    render "shop/categories/edit"
  end

  put :update_category, :with => :id do
    @category = Category.get(params[:id])
    if @category.update(params[:category])
      flash[:notice] = t 'admin.update.success'
      redirect url(:shop, :edit_category, :id => @category.id)
    else
      flash[:notice] = t 'admin.update.failure'
      render 'shop/categories/edit'
    end
  end

  delete :destroy_category, :with => :id do
    category = Category.get(params[:id])
    if category.destroy!
      flash[:notice] = t 'admin.destroy.success'
    else
      flash[:notice] = t 'admin.destroy.failure'
    end
    redirect url(:shop, :categories)
  end

#########################################################################
# Products                                                              #
#########################################################################

  get :products do
    @products = Product.all
    render "shop/products/index"
  end

  get :new_product do
    @product = Product.new
    render 'shop/products/new'
  end

  post :create_product do
    @product = Product.new(params[:product])
    if @product.save
      flash[:notice] = t 'admin.create.success'
      redirect url(:shop, :products)
    else
      logger.error @product.errors.each { |e| e }
      flash[:notice] = t 'admin.create.failure'
      render 'shop/products/new'
    end
  end

  get :edit_product, :with => :id do
    @product = Product.get(params[:id])
    render 'shop/products/edit'
  end

  put :update_product, :with => :id do
    @product = Product.get(params[:id])
    if @product.update(params[:product])
      flash[:notice] = t 'admin.update.success'
      redirect url(:shop, :products)
    else
      flash[:notice] = t 'admin.update.failure'
      render 'shop/products/edit'
    end
  end

  delete :destroy_product, :with => :id do
    product = Product.get(params[:id])
    if product.destroy!
      flash[:notice] = t 'admin.destroy.success'
    else
      flash[:notice] = t 'admin.destroy.failure'
    end
    redirect url(:shop, :products)
  end

end