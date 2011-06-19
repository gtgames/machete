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
      %{<script>window.parent.$("##{params["form_id"]}").trigger("success", #{file.id});</script>}
    else
      %{<script>window.parent.$("##{params["form_id"]}").trigger("error", [#{file.errors.to_json}]);</script>}
    end
  end

  get :reboot do
    require 'fileutils'
    FileUtils.touch(Padrino.root('tmp', 'restart')) if Padrino.env == :development
  end
end
