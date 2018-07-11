require 'rails_helper'

feature 'User can destroy only his answer', %q{
  In order to able delete answer
  As an User
  User must be the author of the question
} do
  let!(:user) { create(:user) }
  let!(:question) {create(:question, user_id: user.id)}
  let!(:my_answer) { create(:answer, question_id: question.id, user_id: user.id) }

  scenario 'Guest do not see link remove' do
    visit question_path(question)
    expect(page).to_not have_link 'Remove'
  end

  scenario 'Authenticated user the author of the question' do
    sign_in(user)
    visit question_path(question)
    expect(page).to have_content my_answer.body
    within '.answers' do
      click_on 'Remove'
    end
    question.reload
    expect(page).to_not have_content my_answer.body
    expect(current_path).to eq question_path(question)
  end
end
