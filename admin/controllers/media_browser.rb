# encoding: UTF-8
Admin.controllers :media_browser do
  get :index do
    @files = Media.all
    render "/media_browser/index", nil, :layout => false
  end

  get :refresh do
    Media.all.to_json
  end

  post :create do
    
  end
end