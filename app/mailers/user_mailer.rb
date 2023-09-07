class UserMailer < ApplicationMailer
  default from: "radhasantos59@gmail.com"

  def pending_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to StockPulse')
  end

  def approved_email(user)
    @user = user
    mail(to: @user.email, subject: 'Your Account Has Been Approved')
  end
end
