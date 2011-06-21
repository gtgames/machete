APP_ROOT = Padrino.root()

Sham.define do
  name        { Faker::Name.first_name                                                      }
  surname     { Faker::Name.last_name                                                       }
  username    { Faker::Internet.user_name                                                   }
  password    { (1..10).map { ('a'..'z').to_a.rand }.join                                   }
  email       { Faker::Internet.email                                                       }
  title       { {"it" => Faker::Lorem.words(5).join(' ')}                                   }
  lead        { {"it" => Faker::Lorem.words(8).join(' ')}                                   }
  text        { {"it" => Faker::Lorem.words(20).join(' ')}                                  }
  slug        { {"it" => Faker::Lorem.words(5).map(&:downcase).map(&:to_ascii).join('-')}   }
  tags        { Faker::Lorem.words(3)                                                       }
  url         { Faker::Internet.domain_name                                                 }
  image       {
    # creating a new temp PNG
    %x{convert -size 600x600  gradient:blue #{Padrino.root('tmp','test.png')} }
    { "name" => Faker::Name.first_name.to_s+'.png',
      "path" => "#{Padrino.root('tmp', 'test.png')}",
      "content_type" => "image/png" }                                                       }
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

Configuration.blueprint do
  _id   { Sham.name.downcase }
  val   { {:foo => "bar"}.to_json }
end
