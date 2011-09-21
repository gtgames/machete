Admin.controllers :cerca_hotel do

  get :index do
    @accounts = Hotel.all
    render 'cercahotel/index'
  end

  get :new do
    @account = Account.new
    render 'accounts/new'
  end

  post :create do
    @account = Account.new(params[:account])
    if @account.save
      flash[:notice] = t'created'
      redirect url(:accounts, :index)
    else
      render 'accounts/new'
    end
  end

  get :edit, :with => :id do
    @account = Account.find(params[:id])
    render 'accounts/edit'
  end

  put :update, :with => :id do
    @account = Account.find(params[:id])
    if @account.update_attributes(params[:account])
      flash[:notice] = t'updated'
      redirect url(:accounts, :index)
    else
      render 'accounts/edit'
    end
  end

  delete :destroy, :with => :id do
    account = Account.find(params[:id])
    if account != current_account && account.destroy
      flash[:notice] = t'destroy.success'
    else
      flash[:error] = t'destroy.fail'
    end
    redirect url(:accounts, :index)
  end
end