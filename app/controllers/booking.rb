Machete.controllers :booking do
  get :index do
    @booking = Booking.new
    render 'booking/index', :layout => Cfg.layout('booking')
  end
  post :new do
    @booking = Booking.new params[:booking]
    if @booking.save
      deliver(:booking, :new, @booking)

      render 'booking/sent', :layout => Cfg.layout('booking')
    else
      render 'booking/index', :layout => Cfg.layout('booking')
    end
  end
end

Machete.mailer :booking do
  email :new do |booking|
    from "info@#{Cfg[:domain]}"
    reply_to "#{booking.email}"
    to  "info@#{Cfg[:domain]}"
    subject "Nuova richiesta di prenotazione da #{booking.email}"
    locals :booking => booking
    content_type 'multipart/alternative'
    provides :plain, :html
    render 'booking/email'
  end
end
