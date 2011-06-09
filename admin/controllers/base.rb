Admin.controllers :base do

  get :index, :map => "/" do
    render "base/index"
  end

  get :tagblob, :provides => :js do
    # Array union: |
    (Post.tagging | Photo.tagging).to_json
  end

  post :upload do
    %{<script>window.parent.eval('$("##{params["form_id"]}").trigger("success", [#{params["file"].to_json}]);');</script>}
  end

  get :reboot do
    require 'fileutils'
    FileUtils.touch(Padrino.root('tmp', 'restart')) if Padrino.env == :development
  end
end
