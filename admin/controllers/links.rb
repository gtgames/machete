Admin.controllers :links do

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
      flash[:notice] = 'Link was successfully created.'
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
      flash[:notice] = 'Link was successfully updated.'
      redirect url(:links, :index)
    else
      render 'admin/links/edit'
    end
  end

  delete :destroy, :with => :id do
    link = Link.find(params[:id])
    if link.destroy
      flash[:notice] = 'Link was successfully destroyed.'
    else
      flash[:error] = 'Impossible destroy Link!'
    end
    redirect url(:links, :index)
  end
end
