Admin.controllers :booking do
  get :index do
    @books = Booking.where(:status => {:'$nin' => [-1]}).order(:_id)
    render "admin/booking/index"
  end
  get :trash do
    @books = Booking.where(:status => {:'$in' => [-1]}).order(:_id)
    render "admin/booking/index"
  end

  get :show, :with => :id do
  	@book = Booking.find(params[:id])
  	render 'admin/booking/show'
  end

  delete :destroy, :with => :id do
  	book = Booking.set({:_id => params[:id]}, :status => -1)
  	flash[:notice] = 'Cestinato con successo.'
  	redirect url(:booking, :index)
  end
end
