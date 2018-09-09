require 'rails_helper'
require 'pry'

RSpec.describe QuestionsController, type: :controller do
  sign_in_user
  let!(:question) { create(:question, user: @user) }

  describe 'GET #show' do

    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'render show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { get :new }
    it 'assign a new Question to @question' do
      binding.pry
      expect(assigns(:question)).to be_a_new(Question)
    end
    it 'render new view' do
      expect(response).to render_template :new
    end

    it 'build new attachment for question' do
      expect(assigns(:question).attachments.first).to be_a_new(Attachment)
    end
  end

  describe 'POST #create' do
    sign_in_user
    context 'with valid attributes' do
      it 'save the new question in the db' do
        expect { (post :create, params: { question: attributes_for(:question) }) }.to change(Question, :count)
      end
      it 'redirect to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response). to redirect_to question_path(assigns(:question))
      end
    end
    context 'with invalid attributes' do
      it 'don`t save question in db' do
        expect { (post :create, params: { question: attributes_for(:invalid_question) }) }.to_not change(Question, :count)
      end
      it 're-render new view' do
        post :create, params: { question: attributes_for(:invalid_question) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    context 'Author is valid' do

    let!(:question) { create(:question, user: @user) }
      it 'delete question from db' do
        expect { (delete :destroy, params: { id: question }) }.to change(@user.questions, :count).by(-1)
      end
      it 'redirect to index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end

    end
  end

  describe 'PATCH #update' do

    context 'with vald attributes' do
      let(:valid) { patch(:update, params: { id: question,  question: attributes_for(:question)}) }

      it 'assigns the requested question to @question' do
        valid
        expect(assigns(:question)).to eq question
      end

       it 'assigns requested question to @question' do
        patch(:update, params: {id: question, question: attributes_for(:question) }, format: :js)
        expect(assigns(:question)).to eq question
      end
    end
  end

end
