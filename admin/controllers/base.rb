Admin.controllers :base do

  get :index, :map => "/" do
    render "base/index"
  end

  get :tagblob, :provides => :js do
    Post.find({}, {:tags => 1 }).to_json
  end
end
