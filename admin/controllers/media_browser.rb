# encoding: UTF-8
Admin.controllers :media_browser do
  get :index do
    @media = Media.all
    render "/media_browser/index", nil, :layout => false
  end

  get :refresh do
    if params[:id]
      file = Media[params[:id]]
      return { mimetype: file.type, url: file.file.url }.to_json unless file.nil?
    end
    return ''
  end

  post :create do
    return "{success:false}" if env["rack.request.form_hash"]["file"].nil?
    media = Media.new
    media.file = env["rack.request.form_hash"]["file"]
    if (media.save() rescue false)
      return "{success:true,id:#{media.id}}"
    else
      return "{error:#{media.errors}}"
    end
  end

  delete :destroy, :with => :id do
    media = Media[params[:id]]
    
    if media.destroy
      flash[:notice] = t 'admin.destroy.success'
    else
      flash[:error] = t 'admin.destroy.failure'
    end
    redirect url(:media, :index)
  end
end