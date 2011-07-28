APP_ROOT = Padrino.root()

Sham.define do
  name        { Random.firstname                                                            }
  surname     { Random.lastname                                                             }
  username    { Random.firstname.to_slug                                                    }
  password    { (1..10).map { ('a'..'z').to_a.rand }.join                                   }
  email       { Random.email                                                                }
  title       { {"it" => "#{ Random.alphanumeric(Random.rand(10)) } "*3 }                   }
  lead        { {"it" => Random.paragraphs(3) }                                             }
  text        { {"it" => Random.paragraphs(10) }                                            }
  slug        { {"it" => ("#{ Random.alphanumeric(Random.rand(10)) } "*3).to_slug }         }
  tags        { [Random.alphanumeric(Random.rand(10)), Random.alphanumeric(Random.rand(10))]}
  url         { Random.lastname.to_slug + '.com'                                            }
  image       {
    # creating a new temp PNG
    %x{convert -size 600x600  gradient:blue #{Padrino.root('tmp','test.png')} }
    { "name" => Random.firstname.to_s+'.png',
      "path" => "#{Padrino.root('tmp', 'test.png')}",
      "content_type" => "image/png" }                                                       }
  ip          { '127.0.0.1'                                                                 }
  ua          { 'Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20100101 Firefox/5.0'        }
  ref         { 'http://' + Random.lastname.to_slug + '.com/'                               }
  phone       { Random.phone                                                                }
end


Account.blueprint do
  name                    { Sham.name     }
  surname                 { Sham.surname  }
  username                { Sham.username }
  email                   { Sham.email    }
  password                { 'testest'     }
  password_confirmation   { 'testest'     }
  role                    { 'admin'       }
end

Post.blueprint do
  title     { Sham.title }
  slug      { Sham.slug }
  lead      { Sham.lead }
  text      { Sham.text }
end

Page.blueprint do
  title     { Sham.title }
  slug      { Sham.slug }
  lead      { Sham.lead }
  text      { Sham.text }
  tags      { Sham.tags }
end

Taxonomy.blueprint do
  title
  description { Sham.text }
end

MediaFile.blueprint do
  name          { Sham.image['name'] }
  content_type  { Sham.image['content_type'] }
  path          { Sham.image['path'] }
end

Photo.blueprint do
  title   { Sham.title }
end

Link.blueprint do
  title   { Sham.title }
  url     { {"it" => Sham.url} }
end

Message.blueprint do
  author  { Sham.name + ' ' + Sham.surname }
  email
  text
  phone

  ip
  ua
  ref
end
