#encoding: utf-8
Admin.helpers do
  def image_lazy thumb, w='100', h='100'
    '<img src="/images/blank.gif" data-src="' << thumb << '" class="lazy" width="' << w << '" height="' << h << '">'
  end
end
