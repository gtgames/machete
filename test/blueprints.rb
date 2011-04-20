Sham.define do
  name        { Faker::Name.first_name                    }
  surname     { Faker::Name.last_name                     }
  username    { Faker::Internet.user_name                 }
  password    { (1..10).map { ('a'..'z').to_a.rand }.join }
  email       { Faker::Internet.email                     }
  title       { Faker::Lorem.words(5).join(' ')           }
  lead        { Faker::Lorem.words(8).join(' ')           }
  text        { Faker::Lorem.words(20).join(' ')          }
  tags        { Faker::Lorem.words(3)                     }
  url         { Faker::Internet.domain_name               }
end


Account.blueprint do
  name                    { Sham.name     }
  surname                 { Sham.surname  }
  username                { Sham.username }
  email                   { Sham.email    }
  password                { 'testy'       }
  password_confirmation   { 'testy'       }
  role                    { 'admin'       }
end

Post.blueprint do
  title     { Sham.title }
  lead      { Sham.lead }
  text      { Sham.text }
  tags      { Sham.tags }
end

Page.blueprint do
  title     { Sham.title }
  lead      { Sham.lead }
  text      { Sham.text }
  tags      { Sham.tags }
end
