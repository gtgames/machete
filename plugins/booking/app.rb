class Booking < BasicApplication
  set :views, Padrino.root('templates')

  register PadrinoFields
  set :default_builder, 'PadrinoFieldsBuilder'
  PadrinoFields::Settings.configure do |config|
    config.container = :div
    config.label_required_marker = "<abbr>*</abbr>"
    config.label_required_marker_position = :append
  end

  layout Cfg.layout(:booking)
end

Booking.controllers do
  get :index do
    @booking = BookRequest.new
    render 'booking/index', :layout => Cfg.layout('booking')
  end
  post :new do
    @booking = BookRequest.new params[:book_request]
    if @booking.save
      deliver(:booking, :new, @booking)

      render 'booking/sent', :layout => Cfg.layout('booking')
    else
      render 'booking/index', :layout => Cfg.layout('booking')
    end
  end
end

Booking.mailer :booking do
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
