Admin.controllers :configurations do
  get :index do
    Cfg.insert 'title', {} if Cfg[:title].nil?
    Cfg.insert 'homepage', {} if Cfg[:homepage].nil?

    render 'admin/configurations/index'
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
    Cfg.insert 'card', {} if Cfg[:card].nil?

    render 'admin/configurations/vcard'
  end
  post :vcard_update do
    card = {}
    params["card"].each{|k, v| card[k] = v }

    Cfg.insert 'card',  card
    Cfg.insert 'vcard', params["vcard"]
    Cfg.insert 'hcard', params["hcard"]

    render 'admin/configurations/vcard'
  end
end
