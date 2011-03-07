email     = 'info@frenzart.com'
password  = 'N0str4PWD'


shell.say ""

account = Account.create(:email => email, :name => "Foo", :surname => "Bar", :password => password, :password_confirmation => password, :role => "root")

unless account.nil? or not account.valid?
  shell.say "================================================================="
  shell.say "Account has been successfully created, now you can login with:"
  shell.say "================================================================="
  shell.say "   email:    #{email}"
  shell.say "   password: #{password}"
  shell.say "   access:   root"
  shell.say "================================================================="
else
  shell.say "Sorry but some thing went worng!"
  shell.say ""
  account.errors.full_messages.each { |m| shell.say "   - #{m}" } unless account.nil?
end

shell.say ""

if PADRINO_ENV == 'development'
  require "faker"

  def pages
    10.times do
      Page.create ({
        title: Faker::Company.bs,
        text: "<p>#{Faker::Lorem.paragraphs(3).join('</p><p>')}</p>",
        parent_id: 0,
        tag_list: Faker::Lorem.words.join(', ')
      })
    end
  end

  def posts
    1.upto(10) do
      Post.create({
        title: Faker::Company.bs,
        text: "<p>#{Faker::Lorem.paragraphs(3).join('</p><p>')}</p>",
        subtitle: Faker::Lorem.paragraph,
        tag_list: Faker::Lorem.words.join(', ')
      })
    end
  end

  if shell.yes?("create fake data?")
    pages
    posts
  end
end