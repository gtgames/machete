Admin.controllers :booking do
  get :index do
    @books = BookRequest.where(:st => {:'$nin' => [-1]}).order(:_id)
    render "/booking/admin/index"
  end
  get :trash do
    @books = BookRequest.where(:st => {:'$in' => [-1]}).order(:_id)
    render "/booking/admin/index"
  end

  get :show, :with => :id do
  	@book = BookRequest.find(params[:id])
  	@book.set(:st => 0)
  	render '/booking/admin/show'
  end

  delete :destroy, :with => :id do
  	book = BookRequest.set({:_id => params[:id]}, {:st => -1})
  	flash[:notice] = 'Cestinato con successo.'
  	redirect url(:booking, :index)
  end
end
