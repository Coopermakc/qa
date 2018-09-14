require_relative 'acceptance_spec'
#require 'rails_helper'


feature 'User create answer on the question', %q{
  User can giveanswer on the question
 } do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  background do
    user.confirm
    sign_in(user)
    visit question_path(question)
  end


  scenario 'User create answer the question', js: true do
    fill_in 'Your answer', with: 'Text of the answer'
    click_on 'Create'
    expect(page).to have_content 'Your answer successfully create.'
    within '.answers' do
      expect(page).to have_content 'Text of the answer'
    end
  end

  scenario 'User try create invalid answer', js: true do
    click_on 'Create'
    expect(page).to have_content "Body can't be blank"
  end

end
