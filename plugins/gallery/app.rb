class Gallery < BasicApplication
  set :views, Padrino.root('templates')
  layout Cfg.layout(:gallery)
end

Gallery.controllers do

  get :index do
    @galleries = Photo.galleries.map do |g|
      Photo.where(:gallery => g)
    end
    render 'gallery/index', :layout => Cfg.layout('gallery')
  end

  get :show, :map => '/:gallery' do
    @photos = Photo.where(:gallery_slug => params[:gallery]).all
    render 'gallery/show', :layout => Cfg.layout('gallery')
  end

end
