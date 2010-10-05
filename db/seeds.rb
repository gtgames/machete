action = shell.ask("Auto[M]igrate or Auto[U]pgrade (blank for nothing)")

if action.downcase == 'm'
  shell.say "auto_migrating! ..."
  DataMapper.auto_migrate!
elsif action.downcase == 'u'
  shell.say "auto_upgrading! ..."
  DataMapper.auto_upgrade!
else
  shell.say "... doing nothing"
end


email     = 'frenz@frenz.com'
password  = 'frenz'

shell.say ""

account = Account.create(:email => email, :name => "Frenz", :surname => "FrenFrenz", :password => password, :password_confirmation => password, :role => "admin")

if account.valid?
  shell.say "================================================================="
  shell.say "Testing Account has been successfully created as:"
  shell.say "   email: #{email}"
  shell.say "   password: #{password}"
  shell.say "================================================================="
else
  shell.say "Sorry but some thing went worng!"
  shell.say ""
  account.errors.full_messages.each { |m| shell.say "   - #{m}" }
end

shell.say ""
