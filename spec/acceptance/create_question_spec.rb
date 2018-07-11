require 'rails_helper'


feature 'User can ask a question', %q{
  User can create question
  User can watch list questions
 } do
  given(:user) { create(:user) }


  scenario 'Authenticated user create a question' do

   sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Title of the question'
    fill_in 'Text', with: 'Body of the question'
    click_on 'Create'

    expect(page).to have_content 'Question successfully created.'
  end

  scenario 'Non-authentificated user ties create question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario 'User watch list a question' do

    visit questions_path

  end
end
