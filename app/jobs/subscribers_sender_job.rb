class SubscribersSenderJob < ApplicationJob
  queue_as :default

  def perform(answer)
    answer.question.subscriptions.find_each do |subscription|
      SubscribersMailer.delay.mailer(subscription.user, answer)
    end
  end
end
