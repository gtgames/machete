Admin.controllers :maintaince do

  get :index do
    render 'maintainance/index'
  end

  get :edit do
    @message = (File.esists?(PADRINO_ROOT + '._maintainance'))? File.read(PADRINO_ROOT + '._maintainance') : ''
    render 'maintainance/edit'
  end
  
  post :create do
    if (File.exists?)
      flash[:notice] = 'Aphorism was successfully created.'
      redirect url(:aphorisms, :edit, :id => @aphorism.id)
    else
      render 'maintainance/edit'
    end
  end


  put :enable do
  end
  
  delete :disable do
    if File.exists?(PADRINO_ROOT + '._maintainance')
      
      flash[:notice] = 'Maintainance disabled'
    else
      flash[:error] = 'ERROR while disabling maintainance'
    end
    redirect url(:aphorisms, :index)
  end
end
