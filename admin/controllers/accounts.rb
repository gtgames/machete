# encoding: UTF-8
Admin.controllers :accounts do

  get :index do
    @accounts = Account.all
    render 'accounts/index'
  end

  get :new do
    @account = Account.new
    render 'accounts/new'
  end

  post :create do
    @account = Account.new(params[:account])
    if (@account.save rescue false)
      flash[:notice] = t 'admin.create.success'
      redirect url(:accounts, :edit, :id => @account.id)
    else
      render 'accounts/new'
    end
  end

  get :edit, :with => :id do
    @account = Account[params[:id]]
    render 'accounts/edit'
  end

  put :update, :with => :id do
    @account = Account[params[:id]]
    if @account.modified! && @account.update(params[:account])
      flash[:notice] = t 'admin.update.success'
      redirect url(:accounts, :edit, :id => @account.id)
    else
      render 'accounts/edit'
    end
  end

  delete :destroy, :with => :id do
    account = Account[params[:id]]
    if account != current_account && account.destroy
      flash[:notice] = t 'admin.destroy.success'
    else
      flash[:error] = t 'admin.destroy.failure'
    end
    redirect url(:accounts, :index)
  end
end