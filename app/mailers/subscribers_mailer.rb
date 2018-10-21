class SubscribersMailer < ApplicationMailer

  def mailer(user, answer)

    @answer = answer

    mail to: user.email
  end
end
