#encoding: utf-8
Admin.controller :taxonomy do
  after do
    if env["REQUEST_METHOD"] != "GET"
      Cfg[:locales].each do |l|
        Padrino.cache.delete("taxonomy_tree_#{l}")
      end
    end
  end

  get :index do
    @taxonomy = Taxonomy.sort(:path.asc).all
    render 'admin/taxonomy/index'
  end

  get :new do
    @taxonomy = Taxonomy.new
    render 'admin/taxonomy/new'
  end

  post :create do
    @taxonomy = Taxonomy.new(params[:taxonomy])
    if @taxonomy.save
      flash[:info] = t 'created'
      redirect url(:taxonomy, :index)
    else
      render 'admin/taxonomy/new'
    end
  end

  get :edit, :with => :id do
    @taxonomy = Taxonomy.find(params[:id])
    render 'admin/taxonomy/edit'
  end

  put :update, :with => :id do
    @taxonomy = Taxonomy.find(params[:id])
    if @taxonomy.update_attributes(params[:taxonomy])
      flash[:info] = t'updated'
      redirect url(:taxonomy, :index)
    else
      render 'admin/taxonomy/edit'
    end
  end

  delete :destroy, :with => :id do
    taxonomy = Taxonomy.find(params[:id])
    if taxonomy.destroy
      flash[:info] = t'destroy.success'

      (request.xhr?)? 200 : redirect(url(:taxonomy, :index))
    else
      flash[:error] = t'destroy.fail'

      (request.xhr?)? 500 : redirect(url(:taxonomy, :index))
    end
  end

  get :tree, :provides => :js do
    Taxonomy.threaded('', true).to_json
  end
end
