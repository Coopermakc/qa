require 'rails_helper'
require 'pry'

RSpec.describe SubscriptionsController, type: :controller do
  sign_in_user
  let!(:question) {create(:question, user: @user)}
  let!(:subscription) {create(:subscription, user: @user, question_id: question.id)}

  describe "POST#create" do
    it 'assigns auth user can subscribe' do
      expect { (post :create, params: {subscription: attributes_for(:subscription)}) }.to change(@user.subscriptions, :count).by(1)
    end

  end
end
