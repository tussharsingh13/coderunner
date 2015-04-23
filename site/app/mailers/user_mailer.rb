class UserMailer < ApplicationMailer
default from: 'notificationsbtech@example.com'

def send_admin_email(user)
    email = 'ujjwal.relan@gmail.com'
    @user = user
    @url  = 'http://localhost:3000/actions/adminrights'
    mail(from: @user.email, to: email, subject: 'IMP: Request for Becoming Admin')
  end  
end
