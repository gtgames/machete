Shoppy.helpers do
  def menu
    Menu.all :order => [:weigth.asc]
  end
end