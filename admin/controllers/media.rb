#encoding: utf-8
Admin.controllers :multimedia do
  layout false

  get :index do
    if defined? Photo
      @photos = Photo.fields(:'file._id').all.map{|e|
        if not e['file'].nil?
          e['file']['_id'].to_s
        end
      }
    else
      @photos = []
    end
    @media = MediaFile.where(:_id => {:$nin => @photos}).all
    (request.xhr?)? @media.to_json : render('admin/multimedia/index')
  end

  get :new do
    redirect url(:multimedia, :index)
  end

  post :create do
    media = Media.new(params[:media])
    (request.xhr?)? 200 : render('admin/multimedia/new')
  end

  delete :destroy, :with => [:id] do
    if MediaFile.find(params[:id]).destroy
      (request.xhr?)? 200 : redirect(url(:multimedia, :index))
    else
      (request.xhr?)? {error: 'not found ID: ' << params[:id]} : "Error deleting File!!!"
    end
  end

  get :dialog, :with => :kind do
    case params[:kind]
    when 'image' then
      @files = MediaFile.where(:content_type => /^image\/\w+/).all
    when 'file' then
      @files = MediaFile.all
    end
    render 'admin/multimedia/files', :layout => false
  end
end
