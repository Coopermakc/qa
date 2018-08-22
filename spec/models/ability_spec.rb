require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other) { create :user }
    let(:question) { create :question, user: user }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    context 'Question' do
      it { should be_able_to :create, Question }
      it { should be_able_to :update, create(:question, user: user), user: user }
      it { should_not be_able_to :update, create(:question, user: other), user: user }
    end
    context 'Answer' do
      it { should be_able_to :create, Answer }
      it { should be_able_to :update, create(:answer, user: user, question: question), user: user }
      it { should_not be_able_to :update, create(:answer, user: other, question: question ), user: user}
    end
    context 'Comment' do
      it { should be_able_to :create, Comment }
    end
    context 'me' do
      it { should be_able_to :me, user, user: user }
      it { should_not be_able_to :me, other, user: user }
    end
end
end
