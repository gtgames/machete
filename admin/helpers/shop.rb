# encoding:utf-8
Admin.helpers do
  def category_options
    c = Category.all
    a = Array.new
    c.each do |z|
      a << [z.name, z.id]
    end
    a
  end

end