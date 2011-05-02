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

account = Account.new( :username => username, :email => email, :name => "GT", :surname => "Games", :password => password, :password_confirmation => password, :role => "admin")

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

if File.exists? Padrino.root('Application.json')
  JSON.parse( File.read( Padrino.root('Application.json') )).each do |c|
    begin
      Configuration.new(c).save
    rescue e
      shell.say "An error occurred creating the Configuration collection: #{e}"
    end
  end
else
  shell.say "No Application.json found, cannot continue building Configuration."
end
