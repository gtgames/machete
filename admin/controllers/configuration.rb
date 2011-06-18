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
    @configuration = Configuration.new(:_id => params[:configuration][:_id], :val => JSON.parse(params[:configuration][:val]))
    if @configuration.save
      flash[:notice] = 'Configuration was successfully created.'
      redirect url(:configurations, :edit, :id => @configuration.id)
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
    if @configuration.update_attributes(:_id => params[:configuration][:_id], :val => JSON.parse(params[:configuration][:val]))
      flash[:notice] = 'Configuration was successfully updated.'
      redirect url(:configurations, :edit, :id => @configuration.id)
    else
      render 'configurations/edit'
    end
  end

  delete :destroy, :with => :id do
    configuration = Configuration.find(params[:id])
    if configuration.destroy
      flash[:notice] = 'Configuration was successfully destroyed.'
    else
      flash[:error] = 'Impossible destroy Configuration!'
    end
    redirect url(:configurations, :index)
  end
end
