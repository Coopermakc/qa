require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :user }
  it { should validate_presence_of :body }
  it { should accept_nested_attributes_for :attachments }

  describe '.new_answer send' do
    let(:user) { create(:user) }
    let(:question){ create(:question, user: user) }
    let(:answer){ create(:answer, question: question, user: user) }
    it 'should send new_answer after creating answer' do
      expect(AnswerMailer).to receive(:new_answer).with(user).and_call_original
      answer.send_new_answer
    end
  end
end
