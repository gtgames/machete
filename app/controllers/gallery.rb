Machete.controllers :gallery do

  get :index, :map =>'/gallery' do
    @galleries = Photo.galleries.map do |g|
      Photo.where(:gallery => g).skip(rand(Photo.count(:gallery => g))).limit(1).first
    end
    render 'gallery/index'
  end

  get :show, :map => '/gallery/:gallery' do
    Photo.where(:gallery_slug => params[:gallery]).all
    render 'gallery/show'
  end

end
