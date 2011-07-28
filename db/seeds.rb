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

if Padrino.env == :development
  shell.say 'Pupulating Configuration data', :green
  Cfg[:homepage] = {}
  Cfg[:title] = {}
  Cfg[:locales].each do |l|
    Cfg[:homepage][l] = Random.paragraphs
    Cfg[:title][l] = "#{Random.firstname} #{Random.lastname}'s awesome WebSite"
  end

  shell.say 'Creating tree random taxonomies ...', :green
  3.times do
    data = {}
    data[:"title(it)"] = "#{Random.alphanumeric(5)} " * 5
    data[:"slug(it)"] = data[:"title(it)"].to_slug
    data[:"description(it)"] = Random.paragraphs(5)
    t = Taxonomy.new(data)
    t.save
  end

  shell.say 'Creating ten random pages ...', :green
  10.times do
    data = {}
    data[:"title(it)"] = "#{Random.alphanumeric(5)} " * 5
    data[:"slug(it)"] = data[:"title(it)"].to_slug
    data[:"text(it)"] = Random.paragraphs(2)
    data[:"lead(it)"] = Random.paragraphs(5)
    data[:taxonomy] = [ Taxonomy.all[ Random.rand(Taxonomy.count()) ] ]

    p = Page.new(data)
    p.save
  end

end

