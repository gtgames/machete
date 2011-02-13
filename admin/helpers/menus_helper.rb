Admin.helpers do
  def nav_list
    nav = Array.new
    
    nav << [{
      link:   "/imagination/",
      title:  "Galleria Immagini"
    },{
      link:   "/contattaci/",
      title:  "Form di Contatto"
    },{
      link:   "/news/",
      title:  "Indice delle news"
    }]
    Page.all.each do |p|
      nav << {
        link: Frontend.url( :pages, :show, :id => p.id, :slug => p.slug ),
        title: p.title
      }
    end
    nav.flatten
  end
end