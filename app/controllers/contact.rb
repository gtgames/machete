Machete.controller :contact do
  get :index do
    @message = Message.new
    render 'contact/index', :layout => Cfg.layout('contact')
  end

  post :new do
    @message = Message.new params[:message]
    if @message.save
      deliver(:contact, :new, @message)
      render 'contact/sent', :layout => Cfg.layout('contact')
    else
      render 'contact/index', :layout => Cfg.layout('contact')
    end
  end
end

Machete.mailer :contact do
  email :new do |contact|
    from "info@#{Cfg[:domain]}"
    reply_to "#{contact.email}"
    to  "info@#{Cfg[:domain]}"
    subject "Nuova richiesta di informazioni da #{contact.email}"
    content_type 'multipart/alternative'
    provides :plain, :html 
    locals :contact => contact
    render 'contacts/email'
  end
end
