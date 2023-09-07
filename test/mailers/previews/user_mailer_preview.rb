# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/pending_email
  def pending_email
    UserMailer.pending_email
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/approved_email
  def approved_email
    UserMailer.approved_email
  end

end
