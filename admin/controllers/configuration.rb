Admin.controllers :configurations do
  get :index do
    render 'configurations/index'
  end
  post :update do
    Cfg.insert 'title', params['title']
    Cfg.insert 'homepage', params['homepage']
    Cfg.insert 'analytics', params['analytics']
    Cfg.insert 'analyst', params['analyst']
    Cfg.insert 'description', params['description']
    Cfg.insert 'keywords', params['keywords']
    Cfg.insert 'author', params['author']

    render 'configurations/index'
  end
end
