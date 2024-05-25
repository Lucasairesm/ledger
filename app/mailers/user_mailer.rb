class UserMailer < ApplicationMailer

#método welcome_email, que enviará um email para o endereço de email cadastrado do usuário
    default from: 'notifications@example.com'
      
        def welcome_email
          @user = params[:user]
          @url  = 'http://example.com/login'
          mail(to: @user.email, subject: 'Welcome to My Awesome Site')
    end
end
