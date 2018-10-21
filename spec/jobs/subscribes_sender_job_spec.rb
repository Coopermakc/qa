require 'rails_helper'

RSpec.describe SubscribersSenderJob, type: :job do
  #let!(:author){ create(:user) }
  let!(:user){ create(:user) }
  let!(:question){ create(:question, user: user) }
  let!(:answer){ create(:answer, question: question, user: user) }

  it 'send email to subsriber' do
    question.subscriptions.each do |subscription|
      expect(SubscribersMailer).to receive(:mailer).with(subscription.user, answer).and_call_original
    end
    SubscribersSenderJob.perform_now(answer)
  end
end
