require 'rails_helper'
require 'pry'

describe 'Questions api' do
  describe 'GET /index' do
    context 'unauthorized' do
      it 'return 401 status if there is no access token' do
        get '/api/v1/questions', params: { format: :json }
        expect(response.status).to eq 401
      end
      it 'return 401 status if access token is invalid' do
        get '/api/v1/questions', params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end
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
  end
  describe 'GET /show' do
    let(:user){ create(:user) }
    let!(:question){ create(:question, user: user) }
    let!(:comments_for_question){ create_list(:comment, 2, commentable: question, user: user) }
    let!(:attachments_for_question) { create_list(:attachment, 2, attachable: question) }

    context 'unauthorized' do
      it 'return 401 status if there is no access token' do
        get "/api/v1/questions/#{question.id}", params: { format: :json }
        expect(response.status).to eq 401
      end
      it 'return 401 status if access token is invalid' do
        get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
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
      it 'contains comments' do
        expect(response.body).to have_json_size(2).at_path('question/comments')
      end
      it 'contains attachments' do

        expect(response.body).to have_json_size(2).at_path('question/attachments')
      end
    end
  end
end
