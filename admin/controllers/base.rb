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
    if current_account.role == :root
      require 'fileutils'
      FileUtils.touch(Padrino.root('tmp', 'restart'))
      flash[:error] = 'touched $root/tmp/restart !!!'
      redirect '/'
    else
      redirect '/'
    end
  end

  get :reless do
    if current_account.role == :root
      lambda {
        # compile less files in a fork
        puts 'Compiling less files'
        path = ::File.expand_path('../public/stylesheets', __FILE__)
        Dir.glob(::File.expand_path('../public/stylesheets/*.less', __FILE__)) {|f|
          f = f.sub(path, '').sub(/^\//, '')
          puts "compiling #{path} / #{f}" 
          `cd #{path} && lessc #{f} > #{f.sub(/less$/, 'css')} --compress`
        }
      }.call()
    end
    flash[:error] = 'less files compiled!'
    redirect '/'
  end
end
