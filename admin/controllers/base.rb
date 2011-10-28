Admin.controllers :base do
  enable :caching

  get :index, :map => "/" do
    render "admin/base/index"
  end

  get :tagblob, :provides => :js do
    content_type :json
    cache('tagblob', :expires_in => 15*60) do
      (Post.tagging | Photo.tagging | Event.tagging).to_json
    end
  end

  post :upload do
    content_type :json
    file = MediaFile.new({
        :name => params["filename"],
        :content_type => Wand.wave(params['tempfile']),
        :path => params['tempfile']
    })
    if file.save
      {success:file.id.to_s, data:file, url:file.thumb()}.to_json
    else
      {error:file.errors}.to_json
    end
  end

  get :reboot do
    if Padrino.env == :development
      require 'fileutils'
      FileUtils.touch(Padrino.root('tmp', 'restart'))
      flash[:error] = 'touched $root/tmp/restart !!!'
      redirect '/'
    else
      redirect '/'
    end
  end
  
  get :reload do
    Padrino.reload!
    flash[:notice] = 'reloading code base!'
    redirect '/'
  end
end
