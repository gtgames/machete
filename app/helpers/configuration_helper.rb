Machete.helpers do
  def configuration key
    c = Configuration.find_one({:key => key})
    return (c.nil?)? 'FOO' : c.value
  end
end