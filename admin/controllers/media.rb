Admin.controllers :multimedia do
  layout false

  get :index do
    render 'multimedia/index'
  end

  get :new do
    ''
  end
  post :create do
    media = Media.new(params[:media])
    render 'multimedia/new'
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
