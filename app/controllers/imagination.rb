Frontend.controllers :imagination do
  get :index, :provides => [:any, :json] do
    @photos = Photo.all
    case content_type
    when :json then
      content_type 'application/json'
      @photos.to_json
    else
      render 'imagination/index', :layout => false
    end
  end

  get :tag, :with => [:tag], :provides => [:any, :json] do
    @photos = Photo.tagged_with params[:tag]
    case content_type
    when :js then
      content_type 'application/json'
      @photos.to_json
    else
      render 'imagination/index', :layout => false
    end
  end
end