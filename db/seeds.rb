# Seed add you the ability to populate your db.
# We provide you a basic shell for interaction with the end user.
# So try some code like below:
#
#   name = shell.ask("What's your name?")
#   shell.say name
#
email     = 'info@frenzart.com'
username  = 'root'
password  = 'N0str4PWD'

shell.say ""

account = Account.new( :username => username, :email => email, :name => "GT", :surname => "Games", :password => password, :password_confirmation => password, :role => "root")

if account.valid?
  shell.say "================================================================="
  shell.say "Account has been successfully created, now you can login with:"
  shell.say "================================================================="
  shell.say "   email: #{email}"
  shell.say "   username: #{username}"
  shell.say "   password: #{password}"
  shell.say "================================================================="
  account.save
else
  shell.say "Sorry but some thing went wrong!"
  shell.say ""
  account.errors.full_messages.each { |m| shell.say "   - #{m}" }
end

shell.say ""

I18n.locale = :en

if Padrino.env == :development
  shell.say 'Creating tree random taxonomies ...', :green
  3.times do
    data = {}
    data[:"title(it)"] = Faker::Lorem.words(5).join(' ')
    data[:"slug(it)"] = data[:"title(it)"].to_slug
    data[:"text(it)"] = Faker::Lorem.words(150).join(' ')
    ap data
    Taxonomy.create(data)
  end

  shell.say 'Creating ten random pages ...', :green
  10.times do
    data = {}
    data[:"title(it)"] = Faker::Lorem.words(5).join(' ')
    data[:"slug(it)"] = data[:"title(it)"].to_slug
    data[:"text(it)"] = Faker::Lorem.words(150).join(' ')
    data[:"lead(it)"] = Faker::Lorem.words(50).join(' ')
    ap data
    data[:taxonomy] = [Taxonomy.all[Random.rand(2)]]

    Page.create(data)
  end

end

