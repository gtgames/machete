Machete.controllers :gallery do

  get :index do
    @galleries = Photo.galleries.map do |g|
      Photo.where(:gallery => g).skip(rand(Photo.count(:gallery => g))).limit(1).first
    end
    render 'gallery/index', :layout => Cfg.layout('gallery')
  end

  get :show, :map => '/gallery/:gallery' do
    @photos = Photo.where(:gallery_slug => params[:gallery]).all
    render 'gallery/show', :layout => Cfg.layout('gallery')
  end

end
