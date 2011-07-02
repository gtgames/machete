Machete.controller :contact do
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
