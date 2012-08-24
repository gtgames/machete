Admin.controllers :photos do

  get :index do
    @photos = Photo.galleries.map do |g|
      { :gallery => g.to_s,
        :photos => Photo.where( :gallery => %r{#{g}}) }
    end
    render 'gallery/admin/index'
  end

  get :new do
    @photo = Photo.new
    render 'gallery/admin/new'
  end

  post :create do
    params[:photo]['file'] = MediaFile.find(params[:photo]['file'])
    @photo = Photo.new(params[:photo])
    if @photo.save
      flash[:info] = 'Photo was successfully created.'
      redirect url(:photos, :edit, :id => @photo.id)
    else
      render 'gallery/admin/new'
    end
  end

  get :edit, :with => :id do
    @photo = Photo.find(params[:id])
    render 'gallery/admin/edit'
  end

  put :update, :with => :id do
    params[:photo]['file'] = MediaFile.find(params[:photo]['file']) unless params[:photo]['file'].nil?
    @photo = Photo.find(params[:id])
    if @photo.update_attributes(params[:photo])
      flash[:info] = 'Photo was successfully updated.'
      redirect url(:photos, :index)
    else
      render 'gallery/admin/edit'
    end
  end

  delete :destroy, :with => :id do
    photo = Photo.find(params[:id])
    if photo.destroy
      flash[:info] = t'destroy.success'

      (request.xhr?)? 200 : redirect(url(:photos, :index))
    else
      flash[:error] = t'destroy.fail'

      (request.xhr?)? 500 : redirect(url(:photos, :index))
    end
  end

  get :import do
    render 'gallery/admin/import'
  end
  post :import_it do
    params['import']['photo'].each do |i|
      i = i[1]
      mf = MediaFile.find(i['media'])
      p = Photo.new({
        :title => mf.name,
        :gallery => params['import']['gallery'],
        :tags => params['import']['tag_list'].gsub(',\s', ',').split(',')
      })
      p.file = mf
      p.save

      sleep(0.5)
    end
    flash[:info] = "Importazione terminata con successo"
    redirect url(:photos, :index)
  end


  post :rename do
    if params[:gallery]
      Photo.set({:gallery => params[:gallery]}, {:gallery => params[:name], :gallery_slug => params[:name].to_slug})
      {name: params[:name]}.to_json
    else
      403
    end
  end
end
