# app/mailers/example_mailer.rb
class ExampleMailer < ApplicationMailer
  default from: 'admin@example.com'

  def test_email(user_id)
    @user = User.find(user_id)
    @extra  = 'Custom Info Here'
    mail(to: @user.email, subject: 'Email sent by replaceappname')
  end
end
