Admin.controllers :system do
  get :index do
    render "system/index"
  end

  post :reboot do
    File.touch Padrino.root('/tmp/restart')
    'Rebooting ...'
  end
end