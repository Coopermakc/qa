require 'rails_helper'

feature 'User delete question which he has created', %q{
  In order to be able delete the question
  As an user
  User must be the author of the question
} do
  let(:current_user) { create(:user) }
  let(:my_question) { create(:question, user_id: current_user.id) }
  let(:alien_question) { create(:question) }

  scenario 'Author of the problem delete his question' do
    sign_in(current_user)
    visit question_path(my_question)
    expect(page).to have_content my_question.body
    click_on 'Remove'
    visit questions_path
    expect(page).to_not have_content my_question.title
  end

  scenario 'User ties delete alien question' do
    sign_in(current_user)
    visit root_path
    expect(page).to_not have_content 'Remove'
  end
  scenario 'Non-registered user ties delete question' do
    visit root_path

    expect(page).to_not have_content 'Remove'
  end

end
