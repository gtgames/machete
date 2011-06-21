Admin.controllers :configurations do

  get :index do
    @configurations = Configuration.all
    render 'configurations/index'
  end

  get :new do
    @configuration = Configuration.new
    render 'configurations/new'
  end

  post :create do
    @configuration = Configuration.new(params[:configuration])
    if @configuration.save
      flash[:notice] = 'Configuration was successfully created.'
      redirect url(:configurations, :index)
    else
      logger.error @configuration.errors
      render 'configurations/new'
    end
  end

  get :edit, :with => :id do
    @configuration = Configuration.find(params[:id])
    render 'configurations/edit'
  end

  put :update, :with => :id do
    @configuration = Configuration.find(params[:id])
    if @configuration.update_attributes(params[:configuration])
      flash[:notice] = t'updated'
      redirect url(:configurations, :edit, :id => @configuration.id)
    else
      render 'configurations/edit'
    end
  end

  delete :destroy, :with => :id do
    configuration = Configuration.find(params[:id])
    if configuration.destroy
      flash[:notice] = t'destroy.success'
    else
      flash[:error] = t'destroy.failure'
    end
    redirect url(:configurations, :index)
  end
end
