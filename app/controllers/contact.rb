Machete.controller :contact, :lang => I18n.locale do
  get :index do
    @message = Message.new
    render 'contact/index'
  end

  post :new do
    @message = Message.new params[:message]
    if @message.save
      render 'contact/sent'
    else
      render 'contact/index'
    end
  end
end
