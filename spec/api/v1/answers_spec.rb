require 'rails_helper'

describe 'Answers api' do
  describe 'GET /index' do
    context 'unauthorized' do
      let(:user){ create(:user) }
      let(:question){ create(:question, user: user) }
      it 'return 401 status if there is no access token' do
        get "/api/v1/questions/#{question.id}/answers", params: { format: :json }
        expect(response.status).to eq 401
      end
      it 'return 401 status if access token is invalid' do
        get "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
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
        it 'answer contains #{attr}' do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
        end
      end
    end
  end
end
