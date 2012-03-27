Admin.helpers do
  def delete_button action, url
    '<button class="delete_button btn btn-action" data-url="' << url << '">' << action.to_s.capitalize << "</button>"
  end

  def edit_button action, url
    '<a href="' << url << '" class="btn btn-default">' << action.to_s.capitalize << '</a>'
  end
end