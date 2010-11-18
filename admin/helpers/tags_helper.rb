Admin.helpers do
  def jstag_list
    tags = Tags.all.map {|t| "'#{t}', "}
    "<script>var tags = [#{tags}]</script>"
  end
end