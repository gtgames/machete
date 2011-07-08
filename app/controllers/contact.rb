Machete.controller :contact do
  get :index do
    @message = Message.new
    render 'contact/index', :layout => Cfg.layout('contact')
  end

  post :new do
    @message = Message.new params[:message]
    if @message.save
      render 'contact/sent', :layout => Cfg.layout('contact')
    else
      render 'contact/index', :layout => Cfg.layout('contact')
    end
  end
end
