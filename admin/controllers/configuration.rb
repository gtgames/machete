Admin.controllers :configurations do
  get :index do
    render 'configurations/index'
  end
  post :update do
    title = {}
    homepage = {}
    Cfg['locales'].each do |l|
      title[l] = params['title'][l]
      homepage[l] = params['homepage'][l]
    end
    Cfg.insert 'title', title
    Cfg.insert 'homepage', homepage


    Cfg.insert 'analytics', params['analytics']
    Cfg.insert 'analyst', params['analyst']
    Cfg.insert 'description', params['description']
    Cfg.insert 'keywords', params['keywords']
    Cfg.insert 'author', params['author']

    render 'configurations/index'
  end

  get :vcard do
    render 'configurations/vcard'
  end
  post :vcard_update do
    Cfg.insert 'vcard', params["vcard"]
    Cfg.insert 'hcard', params["hcard"]
  end
end
