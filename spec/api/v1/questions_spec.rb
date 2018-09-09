require 'rails_helper'
require 'pry'

describe 'Questions api' do
  describe 'GET /index' do
    it_behaves_like "API Authenticable"
    context 'authorized' do
      let(:user){ create(:user) }
      let(:access_token){ create(:access_token) }
      let!(:questions){ create_list(:question, 2, user: user) }
      let(:question){ questions.first }
      let!(:answer){ create(:answer, question: question, user: user) }

      before { get '/api/v1/questions', params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status' do
        expect(response).to be_success
      end
      it 'returns list of the questions' do
        expect(response.body).to have_json_size(2).at_path("questions")
      end
      %w(id title body created_at updated_at).each do |attr|
        it 'question object contains #{attr}' do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end
      context 'answers' do

        it 'included to question object' do
          expect(response.body).to have_json_size(1).at_path("questions/0/answers")
        end
        %w(id body created_at updated_at).each do |attr|
          it 'object contains #{attr}' do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("questions/0/answers/0/#{attr}")
          end
        end
      end
    end
    def do_request(options = {})
      get '/api/v1/questions', params: { format: :json }.merge(options)
    end
  end
  describe 'GET /show' do
    let(:user){ create(:user) }
    let!(:question){ create(:question, user: user) }
    let!(:comments_for_question){ create_list(:comment, 2, commentable: question, user: user) }
    let!(:attachments_for_question) { create_list(:attachment, 2, attachable: question) }
    let!(:comment_for_question) { comments_for_question.first }
    let!(:attachment_for_question) { attachments_for_question.first }

    context 'unauthorized' do
      it_behaves_like "API Authenticable"
      def do_request(options = {})
        get "/api/v1/questions/#{question.id}", params: { format: :json }.merge(options)
      end
    end

    context 'authorized' do
      let(:access_token){ create(:access_token, resource_owner_id: user.id) }
      before { get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status' do
        expect(response).to be_success
      end
      it 'returns list of questions' do
        expect(response.body).to have_json_size(8).at_path('question')
      end
      context 'comments' do
        it 'contains comments' do
          expect(response.body).to have_json_size(2).at_path('question/comments')
        end
        %w(id comment_body user_id created_at updated_at).each do |attr|
          it "object contains #{attr}" do
            expect(response.body).to be_json_eql(comment_for_question.send(attr.to_sym).to_json).at_path("question/comments/1/#{attr}")
          end
        end
      end
      context 'attachments' do
        it 'contains attachments' do
          expect(response.body).to have_json_size(2).at_path('question/attachments')
        end
        it 'contains url' do
          expect(response.body).to be_json_eql(attachment_for_question.file.url.to_json).at_path('question/attachments/1/url')
        end
      end
    end
  end
  describe 'POST /create' do
    context 'unauthorized' do
      it_behaves_like "API Authenticable"
      def do_request(options = {})
        post '/api/v1/questions', params: { format: :json }.merge(options)
      end
    end
    context 'authorized' do
      let(:user){ create(:user) }
      let(:access_token){ create(:access_token, resource_owner_id: user.id) }
      context 'with valid attributes' do
        it 'returns 201 status code' do
          post '/api/v1/questions/', params: { question: attributes_for(:question), format: :json, access_token: access_token.token }
          expect(response).to be_success
        end
        it 'saves a new question in db' do
          expect { (post '/api/v1/questions/', params: { question: attributes_for(:question), format: :json, access_token: access_token.token }) }.to change(user.questions, :count).by(1)
        end
      end
      context 'with invalid attributes' do
        it 'returns 422 status code' do
          post '/api/v1/questions/', params: { question: attributes_for(:invalid_question), format: :json, access_token: access_token.token }
          expect(response.status).to eq 422
        end
        it 'does not save a invalid question in db' do
          expect { (post '/api/v1/questions/', params: { question: attributes_for(:invalid_question), format: :json, access_token: access_token.token }) }.to_not change(Question, :count)
        end
      end
    end
  end
end
