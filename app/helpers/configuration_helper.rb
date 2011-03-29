Machete.helpers do
  def configuration key
    c = Configuration.where(:key => key).first
    return (c.nil?)? 'FOO' : c.value
  end
end