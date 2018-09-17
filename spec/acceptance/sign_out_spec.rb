require 'rails_helper'

feature 'User sign out', %q{
  In order to not be able to ask question
  As an User
  I want to  sign out
  } do

let(:user) { create(:user) }

  scenario 'Registered user try to sign out' do
    user.confirm
    sign_in(user)
    click_on 'Выйти'

    expect(page).to have_content 'Signed out successfully.'
    expect(current_path).to eq root_path
  end

end
