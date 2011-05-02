class Machete < Padrino::Application
  register Padrino::Mailer
  register Padrino::Helpers

  enable :sessions
  enable :flash

  layout  :application

  error 404 do
    render 'errors/404'
  end
end
