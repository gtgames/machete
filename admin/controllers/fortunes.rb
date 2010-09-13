Admin.controllers :fortunes do

  get :index do
    @fortunes = Fortune.all
    render 'fortunes/index'
  end

  get :new do
    @fortune = Fortune.new
    render 'fortunes/new'
  end

  post :create do
    @fortune = Fortune.new(params[:fortune])
    if @fortune.save
      flash[:notice] = t 'admin.create.success'
      redirect url(:fortunes, :edit, :id => @fortune.id)
    else
      render 'fortunes/new'
    end
  end

  get :edit, :with => :id do
    @fortune = Fortune.get(params[:id])
    render 'fortunes/edit'
  end

  put :update, :with => :id do
    @fortune = Fortune.get(params[:id])
    if @fortune.update(params[:fortune])
      flash[:notice] = t 'admin.update.success'
      redirect url(:fortunes, :edit, :id => @fortune.id)
    else
      render 'fortunes/edit'
    end
  end

  delete :destroy, :with => :id do
    menu = Fortune.get(params[:id])
    if fortune.destroy
      flash[:notice] = t 'admin.destroy.success'
    else
      flash[:error] = t 'admin.destroy.failure'
    end
    redirect url(:fortunes, :index)
  end
end
