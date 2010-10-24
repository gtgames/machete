Frontend.mailer :mailer do
  email :info do |name, email, text|
      from 'info@' + DOMAIN_NAME
      to 'info@' + DOMAIN_NAME
      subject "[WEB] #{name} (#{email}) ha chiesto informazioni"
      locals :name => name, :email => email, :text => text
      content_type :html
      charset 'utf-8'
      via :smtp
      render 'mail'
    end
end