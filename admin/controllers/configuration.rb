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
    @configuration = Configuration.new(params[:post])
    if @configuration.save
      flash[:notice] = 'Configuration was successfully created.'
      redirect url(:configurations, :edit, :id => @configuration.id)
    else
      render 'configurations/new'
    end
  end

  get :edit, :with => :id do
    @configuration = Configuration.find(params[:id])
    render 'configurations/edit'
  end

  put :update, :with => :id do
    @configuration = Configuration.find(params[:id])
    if @configuration.update_attributes(params[:post])
      flash[:notice] = 'Configuration was successfully updated.'
      redirect url(:configurations, :edit, :id => @configuration.id)
    else
      render 'configurations/edit'
    end
  end

  delete :destroy, :with => :id do
    post = Configuration.find(params[:id])
    if post.destroy
      flash[:notice] = 'Configuration was successfully destroyed.'
    else
      flash[:error] = 'Impossible destroy Configuration!'
    end
    redirect url(:configurations, :index)
  end
end
