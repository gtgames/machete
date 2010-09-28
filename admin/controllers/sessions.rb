# encoding: UTF-8
Admin.controllers :sessions do

  get :new do
    render "/sessions/new", nil, :layout => false
  end

  post :create do
    if account = Account.authenticate(params[:email], params[:password])
      set_current_account(account)
      redirect url(:base, :index)
    else
      flash[:warning] = t 'admin.login.failure'
      redirect url(:sessions, :new)
    end
  end

  get :destroy do
    set_current_account(nil)
    redirect url(:sessions, :new)
  end
end