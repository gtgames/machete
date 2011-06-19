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
      @files = MultiMedia.where(:content_type => /^image\/\w+/).all
      render 'multimedia/dialog/image'
    when 'file' then
      @files = MultiMedia.all
      render 'multimedia/dialog/file'
    end
  end
end
