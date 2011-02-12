Admin.helpers do
  def cpartial *args
    begin
      partial *args
    rescue
      ''
    end
  end
end