Admin.controllers :photos do

  get :index do
    @photos = Photo.galleries.map do |g|
      { :gallery => g.to_s,
        :photos => Photo.where( :gallery => %r{#{g}}) }
    end
    render 'photos/index'
  end

  get :new do
    @photo = Photo.new
    render 'photos/new'
  end

  post :create do
    params[:photo]['file'] = MediaFile.find(params[:photo]['file'])
    @photo = Photo.new(params[:photo])
    if @photo.save
      flash[:notice] = 'Photo was successfully created.'
      redirect url(:photos, :edit, :id => @photo.id)
    else
      render 'photos/new'
    end
  end

  get :edit, :with => :id do
    @photo = Photo.find(params[:id])
    render 'photos/edit'
  end

  put :update, :with => :id do
    params[:photo]['file'] = MediaFile.find(params[:photo]['file']) unless params[:photo]['file'].nil?
    @photo = Photo.find(params[:id])
    if @photo.update_attributes(params[:photo])
      flash[:notice] = 'Photo was successfully updated.'
      redirect url(:photos, :edit, :id => @photo.id)
    else
      render 'photos/edit'
    end
  end

  delete :destroy, :with => :id do
    photo = Photo.find(params[:id])
    if photo.destroy
      flash[:notice] = 'Photo was successfully destroyed.'
    else
      flash[:error] = 'Impossible destroy Photo!'
    end
    redirect url(:photos, :index)
  end

  get :import do
    @files = Dir.glob(Padrino.root('tmp', 'import', '*'))
    if @files.size == 0
      flash[:notice] = 'Nessun file da importare'
      redirect url(:photos, :index)
    end
    render 'photos/import'
  end
  post :import_it do
    params['import']['photo'].each do |i|
      i = i[1]
      type =  case ::File.extname(i["file"]).slice!(1..-1)
              when /png$/i
                'image/png'
              when /jpe?g$/i
                'image/jpeg'
              else
                'image/image'
              end
      mf = MediaFile.create({
        :name => ::File.basename(i["file"]),
        :path => i["file"],
        :content_type => type
      })
      Photo.create({
        :title => i["title"],
        :file => mf,
        :gallery => params['import']['gallery'],
        :tags => params['import']['tags']
      })
    end
    redirect url(:photos, :index)
  end
end
