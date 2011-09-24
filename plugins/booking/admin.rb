Admin.controllers :booking do
  get :index do
    @books = BookRequest.where(:status => {:'$nin' => [-1]}).order(:_id)
    render "admin/booking/index"
  end
  get :trash do
    @books = BookRequest.where(:status => {:'$in' => [-1]}).order(:_id)
    render "admin/booking/index"
  end

  get :show, :with => :id do
  	@book = BookRequest.find(params[:id])
  	render '/booking/admin/show'
  end

  delete :destroy, :with => :id do
  	book = BookRequest.set({:_id => params[:id]}, :status => -1)
  	flash[:notice] = 'Cestinato con successo.'
  	redirect url(:booking, :index)
  end
end
