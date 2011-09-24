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
      flash[:notice] = 'Photo was successfully created.'
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
      flash[:notice] = 'Photo was successfully updated.'
      redirect url(:photos, :index)
    else
      render 'gallery/admin/edit'
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
    require "find"
    begin
      @files = Find.find(File.expand_path("~/tmp/#{Cfg[:domain]}")).map{|f|
        f unless f.match(/\.(jpe?g|png|gif)$/i).nil?
      }.compact
    rescue Errno::ENOENT
      @files = []
    end

    if @files.size == 0
      flash[:notice] = 'Nessun file da importare'
      redirect url(:photos, :index)
    end
    render 'photos/import'
  end
  post :import_it do
    params['import']['photo'].each do |i|
      i = i[1]
      mf = MediaFile.new({
        :name => ::File.basename(i["file"]),
        :path => i["file"],
        :content_type => Wand.wave(i["file"])
      })
      mf.save
      p = Photo.new({
        :title => i["title"],
        :gallery => params['import']['gallery'],
        :tags => params['import']['tags']
      })
      p.file = mf
      p.save
    end
    redirect url(:photos, :index)
  end


  post :rename do
    if params[:gallery]
      Photo.set({:gallery => params[:gallery]}, {:gallery => params[:name], :gallery_slug => params[:name].to_slug})
      params[:name]
    end
    params[:name]
  end
end
