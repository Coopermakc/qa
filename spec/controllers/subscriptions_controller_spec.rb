require 'rails_helper'
require 'pry'

RSpec.describe SubscriptionsController, type: :controller do
  sign_in_user
  #sign_in_other
  let!(:other_user){ create(:user) }
  let!(:other_question){ create(:question, user: other_user) }
  #let!(:question) {create(:question, user: @user)}
  #let(:subscription) {create(:subscription, user: @other, question_id: question.id)}

  describe "POST#create" do
    it 'assigns auth user can subscribe' do
      expect { (post :create, params: {question_id: other_question.id}, format: :js) }.to change(@user.subscriptions, :count).by(1)
    end
  end
  describe "DELETE#destroy"
    #let!(:other_question) { create(:question, user: @) }
    let(:other_subscription) { create(:subscription, question_id: other_question.id, user: @user) }
    it 'delete subscription' do
      expect { (delete :destroy, params: { id: other_subscription.id, question_id: other_question.id}, format: :js) }.to change(Subscription, :count).by(-1)
    end
end
