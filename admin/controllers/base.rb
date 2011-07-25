Admin.controllers :base do
  enable :caching

  get :index, :map => "/" do
    render "base/index"
  end

  get :tagblob, :provides => :js do
    content_type :json
    cache('tagblob', :expires_in => 10*60) do
      (Post.tagging | Photo.tagging).to_json
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
      {success:file.id.to_s}.to_json
    else
      {error:file.errors}.to_json
    end
  end

  get :reboot do
    require 'fileutils'
    FileUtils.touch(Padrino.root('tmp', 'restart')) if Padrino.env == :development
  end
end
