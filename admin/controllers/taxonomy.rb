Admin.controller :taxonomy do
  get :index do
    @taxonomy = Taxonomy.sort(:_id.desc).all
    render 'taxonomy/index'
  end

  get :new do
    @taxonomy = Taxonomy.new
    render 'taxonomy/new'
  end

  post :create do
    @taxonomy = Taxonomy.new(params[:taxonomy])
    if @taxonomy.save
      flash[:notice] = t 'created'
      redirect url(:taxonomy, :index)
    else
      render 'taxonomy/new'
    end
  end

  get :edit, :with => :id do
    @taxonomy = Taxonomy.find(params[:id])
    render 'taxonomy/edit'
  end

  put :update, :with => :id do
    ap(params)
    @taxonomy = Taxonomy.find(params[:id])
    if @taxonomy.update_attributes(params[:taxonomy])
      flash[:notice] = t'updated'
      redirect url(:taxonomy, :index)
    else
      render 'taxonomy/edit'
    end
  end

  delete :destroy, :with => :id do
    taxonomy = Taxonomy.find(params[:id])
    if taxonomy.destroy
      flash[:notice] = t'destroy.success'
    else
      flash[:error] = t'destroy.fail'
    end
    redirect url(:taxonomy, :index)
  end

  get :tree, :provides => :js do
    Taxonomy.threaded('', true).to_json
  end
end
