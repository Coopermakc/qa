class AnswerMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.answer_mailer.new_answer.subject
  #
  def new_answer(user)
    @greeting = "Hi"

    mail to: user.email
  end
end
