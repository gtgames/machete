#encoding: utf-8
Admin.controllers :links do
  after do
    if env["REQUEST_METHOD"] != "GET"
      Cfg[:locales].each do |l|
        Padrino.cache.delete("nav_#{l}")
      end
    end
  end

  get :index do
    @links = Link.all
    render 'admin/links/index'
  end

  get :new do
    @link = Link.new
    render 'admin/links/new'
  end

  post :create do
    @link = Link.new(params[:link])
    if @link.save
      flash[:info] = 'Link was successfully created.'
      redirect url(:links, :index)
    else
      render 'admin/links/new'
    end
  end

  get :edit, :with => :id do
    @link = Link.find(params[:id])
    render 'admin/links/edit'
  end

  put :update, :with => :id do
    @link = Link.find(params[:id])
    if @link.update_attributes(params[:link])
      flash[:info] = 'Link was successfully updated.'
      redirect url(:links, :index)
    else
      render 'admin/links/edit'
    end
  end

  delete :destroy, :with => :id do
    link = Link.find(params[:id])
    if link.destroy
      flash[:info] = t'destroy.success'

      (request.xhr?)? 200 : redirect(url(:links, :index))
    else
      flash[:error] = t'destroy.fail'

      (request.xhr?)? 500 : redirect(url(:links, :index))
    end
  end
end
