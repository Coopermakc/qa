require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
      sign_in_user
      let!(:question) { create(:question, user: @user) }
      let!(:answer) { create(:answer, question: question, user: @user) }
      let!(:other_user){ create(:user) }
      let!(:other_answer){ create(:answer, question: question, user: other_user) }

  describe 'GET #new' do
    sign_in_user
    before { get :new, params: { question_id: question.id }}
    it 'assign a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end
    it 'render new view' do
      expect(response).to render_template :new
    end

    # it 'build new attachment for answer' do
    #   expect(assigns(:answer).attachments.first).to be_a_new(Attachment)
    # end
  end

  describe 'POST #create' do
    sign_in_user
    context 'with valid attributes' do
      it 'save new answer in db' do
        expect { post(:create, params: { answer: attributes_for(:answer), question_id: question.id, user: @user }) }.to change(question.answers, :count)
      end
      it 'redirect to @question' do
        post(:create, params: { answer: attributes_for(:answer), question_id: question.id }, format: :js)
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'don`t save answer in db' do
        expect { post(:create, params: { answer: attributes_for(:invalid_answer), question_id: question.id }) }.to_not change(question.answers, :count)
      end
      it 're-render new view' do
        post(:create, params: { answer: attributes_for(:invalid_answer), question_id: question.id })
        expect(response).to render_template :new
      end
    end
  end
  describe 'DELETE #destroy' do

    context 'Authenticated user' do
      it 'del own answer' do
        expect{ delete(:destroy, params: { id: answer, user: @user }, format: :js) }.to change(@user.answers, :count).by(-1)
      end
      it 'don`t del alian question' do
        expect{ delete(:destroy, params: { id: answer, question_id: question.id }, format: :js) }.to change(Answer, :count)
      end
      it 'render to questions page' do
        delete(:destroy, params: { id: answer, question_id: question.id}, format: :js)
        expect(response).to render_template :destroy
      end
    end
    context 'Non-authenticated user' do
      it 'can`t delete answer' do
        expect{ delete(:destroy, params: { id: other_answer.id, question_id: question.id }, format: :js) }.to_not change(Answer, :count)
      end
    end
  end

  describe 'PATCH #update' do

    context 'Authenticated user' do
      it 'assigns requested question to @question' do
        patch(:update, params: {id: answer, question_id: question.id, answer: attributes_for(:answer) }, format: :js)
        expect(assigns(:question)).to eq question
      end
      it 'assigns requested answer to @answer' do
        patch(:update, params: {id: answer, question_id: question.id, answer: attributes_for(:answer) }, format: :js)
        expect(assigns(:answer)).to eq answer
      end
      it 'assigns update answers body' do
        patch(:update, params: {id: answer.id, question_id: question.id, answer: { body: 'new body' } }, format: :js)
        answer.reload
        expect(answer.body).to eq 'new body'
      end
      it 'render update template' do
        patch(:update, params: {id: answer, question_id: question.id, answer: attributes_for(:answer), format: :js })
        expect(response).to render_template :update
      end
    end
  end
end
