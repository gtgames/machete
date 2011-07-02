Machete.controllers :booking do
  get :index do
    @booking = Booking.new
    render 'booking/index'
  end
  post :new do
    @booking = Booking.new params[:booking]
    if @booking.save
      render 'booking/sent'
    else
      render 'booking/index'
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
    render 'booking/email'
    content_type 'multipart/alternative'
    provides :plain, :html
  end
end
