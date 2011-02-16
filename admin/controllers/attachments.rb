# encoding:utf-8
Admin.controllers :attachments, :parent => :page do
  get :index do
    @attachments = Attachment.where(:page_id => params[:page_id]).all
    render 'attachments/index'
  end

  get :new do
    @attachment = Attachment.new
    render 'attachments/new'
  end

  post :create do
    @attachment = Attachment.new(
      :name => params[:attachment][:name],
      :file => params[:attachment][:file],
      :page_id => params[:page_id])

    if (@attachment.save rescue false)
      flash[:notice] = t 'admin.create.success'
      redirect url(:attachments, :edit, :page_id => params[:page_id], :id => @attachment.id)
    else
      render 'attachments/new'
    end
  end

  get :edit, :with => :id do
    @attachment = Attachment[params[:id]]
    render 'attachments/edit'
  end

  put :update, :with => :id do
    @attachment = Attachment[params[:id]]
    if @attachment.modified! && @attachment.update(params[:attachment])
      flash[:notice] = t 'admin.update.success'
      redirect url(:attachments, :edit, :id => @attachment.id)
    else
      render 'attachments/edit'
    end
  end

  delete :destroy, :with => :id do
    attachment = Attachment[params[:id]]
    if attachment.destroy
      flash[:notice] = t 'admin.destroy.success'
    else
      flash[:error] = t 'admin.destroy.failure'
    end
    redirect url(:attachment, :index)
  end
end
