require 'rails_helper'
require 'pry'

describe 'Answers api' do
  describe 'GET /index' do
    context 'unauthorized' do
      let(:user){ create(:user) }
      let(:question){ create(:question, user: user) }

      it_behaves_like "API Authenticable"
      def do_request(options = {})
        get "/api/v1/questions/#{question.id}/answers", params: { format: :json }.merge(options)
      end
    end
    context 'authorized' do
      let(:access_token){ create(:access_token) }
      let!(:user){ create(:user) }
      let!(:question){ create(:question, user: user) }
      let!(:answers){ create_list(:answer, 2, question: question, user: user) }
      let(:answer){ answers.first }

      before { get "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: access_token.token } }

      it 'return status 200' do
        expect(response).to be_success
      end
      it 'return list of answers' do
        expect(response.body).to have_json_size(2).at_path("answers")
      end
      %w(id body created_at updated_at).each do |attr|
        it "answer contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
        end
      end
    end
    describe 'GET /show' do
      context 'unauthorized' do
        let(:user){ create(:user) }
        let(:question){ create(:question, user: user) }
        let(:answer){ create(:answer, question: question, user: user) }

        it_behaves_like "API Authenticable"
        def do_request(options = {})
          get "/api/v1/questions/#{question.id}/answers/#{answer.id}", params: { format: :json }.merge(options)
        end
      end
      context 'authrized' do
        let(:access_token){ create(:access_token) }
        let!(:user){ create(:user) }
        let!(:question){ create(:question, user: user) }
        let!(:answers){ create_list(:answer, 2, question: question, user: user) }
        let(:answer){ answers.first }
        let!(:comments){ create_list(:comment, 2, commentable: answer, user: user) }
        let!(:attachments){ create_list(:attachment, 2, attachable: answer) }
        let(:comment){ comments.first }
        let(:attachment){ attachments.first }

        before { get "/api/v1/questions/#{question.id}/answers/#{answer.id}", params: { format: :json, access_token: access_token.token } }
        it 'return status 200' do
          expect(response).to be_success
        end
        context 'comments' do
          it 'contain comments' do
            #binding.pry
            expect(response.body).to have_json_size(2).at_path("answer/comments")
          end
          %w(id comment_body user_id created_at updated_at).each do |attr|
            it 'object contains #{attr}' do
              expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("answer/comments/1/#{attr}")
            end
          end
        end
        context 'attachments' do
           it 'contain comments' do
            #binding.pry
            expect(response.body).to have_json_size(2).at_path("answer/attachments")
          end
          it 'contains url' do
            expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path('answer/attachments/1/url')
          end
        end
      end
    end
  end
  describe 'POST /create' do
    let(:user){ create(:user) }
    let(:question){ create(:question, user: user) }

    context 'unauthorized' do
    
      it_behaves_like "API Authenticable"
      def do_request(options = {})
        post "/api/v1/questions/#{question.id}/answers", params: { format: :json }.merge(options)
      end
    end

    context 'authorized' do
      let(:access_token){ create(:access_token, resource_owner_id: user.id) }
      context 'with valid attributes' do
        it 'returns 201 status code' do
          post "/api/v1/questions/#{question.id}/answers", params: { answer: attributes_for(:answer), format: :json, access_token: access_token.token }
          expect(response).to be_success
        end
        it 'create new answer for user' do
          expect { (post "/api/v1/questions/#{question.id}/answers", params: { answer: attributes_for(:answer), format: :json, access_token: access_token.token }) }.to change(user.answers, :count).by(1)
        end
        it 'create new answer for question' do
          expect { (post "/api/v1/questions/#{question.id}/answers", params: { answer: attributes_for(:answer), format: :json, access_token: access_token.token }) }.to change(question.answers, :count).by(1)
        end
      end
      context 'with invalid attributes' do
        it 'returns 422 status code' do
           post "/api/v1/questions/#{question.id}/answers", params: { answer: attributes_for(:invalid_answer), format: :json, access_token: access_token.token }
           expect(response.status).to eq 422
        end
        it 'does not save invalid answer in db' do
          expect { (post "/api/v1/questions/#{question.id}/answers", params: { answer: attributes_for(:invalid_answer), format: :json, access_token: access_token.token }) }.to_not change(Answer, :count)
        end
      end
    end
  end
end
