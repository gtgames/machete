Admin.controllers :events do

  get :index do
    @events = Event.where().order(:from.desc).all
    render '/events/admin/index'
  end

  get :new do
    @event = Event.new
    render '/events/admin/new'
  end

  post :create do
    params[:event]['file'] = MediaFile.find(params[:event]['file']) unless params[:event]['file'].nil?
    @event = Event.new(params[:event])
    if @event.save
      flash[:notice] = 'Event was successfully created.'
      redirect url(:events, :edit, :id => @event.id)
    else
      render '/events/admin/new'
    end
  end

  get :edit, :with => :id do
    @event = Event.find(params[:id])
    render '/events/admin/edit'
  end

  put :update, :with => :id do
    params[:event]['file'] = MediaFile.find(params[:event]['file']) unless params[:event]['file'].nil?
    @event = Event.find(params[:id])
    if @event.update_attributes(params[:event])
      flash[:notice] = 'Event was successfully updated.'
      redirect url(:events, :edit, :id => @event.id)
    else
      render '/events/admin/edit'
    end
  end

  delete :destroy, :with => :id do
    event = Event.find(params[:id])
    if event.destroy
      flash[:notice] = 'Event was successfully destroyed.'
    else
      flash[:error] = 'Impossible destroy Event!'
    end
    redirect url(:events, :index)
  end
end
