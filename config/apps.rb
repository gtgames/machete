class Imaging < Padrino::Application
  require 'rack_thumb'

  disable :sessions
  disable :flash
  use Rack::Thumb,
    :write => true
end


Padrino.mount("Machete").to('/').host(/^(?!(admin|www\.admin)).*$/)

Padrino.mount("Admin").to("/").host(/^(?:www\.)?admin\..*$/)

Padrino.mount("Imaging").to('/media/')