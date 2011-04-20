Machete.helpers do
  def cfg key
    c = Configuration.first(:key => key.to_s)
    return (c.nil?)? '' : c['value']
  end
end