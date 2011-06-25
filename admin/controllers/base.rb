Admin.controllers :base do

  get :index, :map => "/" do
    render "base/index"
  end

  get :tagblob, :provides => :js do
    # Array union: |
    (Post.tagging | Photo.tagging).to_json
  end

  post :upload do
    file = MediaFile.new({
        :name => params["file"]["filename"],
        :content_type => params["file"]["type"],
        :path => params["file"]["tempfile"]
    })
    if file.save
      %{<html><head><script>document.domain=#{Cfg["domain"]};</script></head><body>{"success":#{file.id.to_s.to_json}}</body></html>}
    else
      %{<html><head><script>document.domain=#{Cfg["domain"]};</script></head><body>{"error":[#{file.errors.to_json}]}</body></html>}
    end
  end

  get :reboot do
    require 'fileutils'
    FileUtils.touch(Padrino.root('tmp', 'restart')) if Padrino.env == :development
  end
end
