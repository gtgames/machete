Machete.controllers :gallery, :lang => I18n.locale do
  get :index, :map =>'/:lang/gallery' do
    @galleries = Photo.galleries.map do |g|
      Photo.where(:gallery => g).skip(rand(Photo.count(:gallery => g))).limit(1).first
    end
    render 'gallery/index'
  end
  get :show, :map => '/:lang/gallery/:gallery' do
    Photo.where(:gallery_slug => params[:gallery]).all
    render 'gellery/show'
  end
end
