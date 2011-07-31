Admin.controllers :multimedia do
  layout false

  get :index do
    @photos = Photo.fields(:'file._id').all.map{|e| e['file']['_id'].to_s  }
    @media = MediaFile.where(:_id => {:$nin => @photos}).all
    render 'multimedia/index'
  end

  get :new do
    redirect url(:multimedia, :index)
  end

  post :create do
    media = Media.new(params[:media])
    render 'multimedia/new'
  end

  delete :destroy, :with => [:id] do
    if MediaFile.find(params[:id]).destroy
      redirect url(:multimedia, :index)
    else
      "Error deleting File!!!"
    end
  end

  get :dialog, :with => :kind do
    case params[:kind]
    when 'image' then
      @files = MediaFile.where(:content_type => /^image\/\w+/).all
      render 'multimedia/images', :layout => false
    when 'file' then
      @files = MediaFile.all
      render 'multimedia/files', :layout => false
    end
  end
end
