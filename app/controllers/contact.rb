Frontend.controllers :contact do

  get :form, :map => "/contattaci/" do
    @mail = Contact.new
    render 'mailers/index'
  end
  post :new, :map => "/contattaci/" do
    @mail = Contact.new params[:mail]

    if @mail.valid? && @mail.classification != 'spam' && (@mail.save rescue false)
      deliver(:mailer, :info, @mail.author, @mail.email, Sanitize.clean(@mail.text))
      flash[:info] = I18n.t 'contact.ok'
      render 'mailers/index'
    else
      flash[:error] = I18n.t 'contact.error'
      render 'mailers/index'
    end
  end
end