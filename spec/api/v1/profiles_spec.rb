require 'rails_helper'
describe 'Profile API' do
  it_behaves_like "API Authenticable"
  end
  context 'authorized' do
    let(:me) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: me.id) }
    before { get('/api/v1/profiles/me', params: { format: :json, access_token: access_token.token }) }

    it 'returns 200 status' do
      expect(response).to be_success
    end

    %w(id email created_at updated_at).each  do |attr|
      it 'contains #{attr}' do
        expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
      end
    end
    %w(password encrypted_password).each do |attr|
      it 'does not contain #{attr}' do
        expect(response.body).to_not have_json_path(attr)
      end
    end
  end
  describe 'GET /index' do
    context 'unauthorized' do
      it 'return 401 status if there is no access token' do
        get '/api/v1/profiles', params: { format: :json }
        expect(response.status).to eq 401
      end
      it 'return 401 status if access token is invalid' do
        get '/api/v1/profiles', params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end
    context 'authorized' do
      let!(:users) { create_list(:user, 4) }
      let(:access_token) {create(:access_token, resource_owner_id: users[0].id)}

      before { get '/api/v1/profiles', params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status' do
        expect(response).to be_success
      end
      it 'not contain current_resource_owner' do
        expect(response.body).to_not include_json(users[0].to_json)
      end
      %w(id email created_at updated_at).each  do |attr|
      it 'contains #{attr}' do
        expect(response.body).to be_json_eql(users[1].send(attr.to_sym).to_json).at_path("0/#{attr}")
      end
    end
    %w(password encrypted_password).each do |attr|
      it 'does not contain #{attr}' do
        expect(response.body).to_not have_json_path("0/#{attr}")
      end
    end
  end
  def do_request(options = {})
    get '/api/v1/profiles/me', params: { format: :json, options }.merge(options)
  end
end
