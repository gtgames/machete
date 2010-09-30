# encoding:utf-8
Admin.controllers :languages do

  get :index do
    @languages = Language.all
    render 'languages/index'
  end

  get :new do
    @language = Language.new
    render 'languages/new'
  end

  post :create do
    @language = Language.new(params[:language])
    if @language.save
      flash[:notice] = t 'admin.create.success'
      redirect url(:languages, :index)
    else
      render 'languages/new'
    end
  end

  get :edit, :with => :id do
    @language = Language.get(params[:id])
    render 'languages/edit'
  end

  put :update, :with => :id do
    @language = Language.get(params[:id])
    if @language.update(params[:language])
      flash[:notice] = t 'admin.update.success'
      redirect url(:languages, :index)
    else
      render 'languages/edit'
    end
  end

  delete :destroy, :with => :id do
    language = Language.get(params[:id])
    if language.destroy
      flash[:notice] = t 'admin.destroy.success'
    else
      flash[:error] = t 'admin.destroy.failure'
    end
    redirect url(:languages, :index)
  end
end