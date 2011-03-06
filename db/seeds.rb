email     = 'info@frenzart.com'
password  = 'N0str4PWD'


shell.say ""

account = Account.create(:email => email, :name => "Foo", :surname => "Bar", :password => password, :password_confirmation => password, :role => "root")

if account.valid?
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
  account.errors.full_messages.each { |m| shell.say "   - #{m}" }
end

shell.say ""