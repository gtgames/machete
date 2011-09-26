Admin.controllers :messages do
  get :index do
    @messages = Message.where(:st => {:'$nin' => [-1]}).order(:_id)
    render "admin/messages/index"
  end
  get :trash do
    @messages = Message.where(:st => {:'$in' => [-1]}).order(:_id)
    render "admin/messages/index"
  end

  get :show, :with => :id do
  	@message = Message.find(params[:id])
  	@message.set(:st => 0)
  	render 'admin/messages/show'
  end

  delete :destroy, :with => :id do
  	message = Message.set({:_id => params[:id]}, {:st => -1})
  	flash[:notice] = 'Cestinato con successo.'
  	redirect url(:messages, :index)
  end
end
