#encoding: utf-8
Admin.controllers :accounts do

  get :index do
    @accounts = Account.all
    render 'admin/accounts/index'
  end

  get :new do
    @account = Account.new
    render 'admin/accounts/new'
  end

  post :create do
    @account = Account.new(params[:account])
    if @account.save
      flash[:info] = t'created'
      redirect url(:accounts, :index)
    else
      render 'admin/accounts/new'
    end
  end

  get :edit, :with => :id do
    @account = Account.find(params[:id])
    render 'admin/accounts/edit'
  end

  put :update, :with => :id do
    @account = Account.find(params[:id])
    if @account.update_attributes(params[:account])
      flash[:info] = t'updated'
      redirect url(:accounts, :index)
    else
      render 'admin/accounts/edit'
    end
  end

  delete :destroy, :with => :id do
    account = Account.find(params[:id])
    if account != current_account && account.destroy
      flash[:info] = t'destroy.success'

      (request.xhr?)? 200 : redirect(url(:accounts, :index))
    else
      flash[:error] = t'destroy.fail'

      (request.xhr?)? 500 : redirect(url(:accounts, :index))
    end

  end
end
