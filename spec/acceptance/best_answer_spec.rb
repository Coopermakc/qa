require_relative 'acceptance_spec.rb'

feature 'Athor of the question choose best answer', %q{
  In order to choose the best answer
  As an author of the question
  User can match best answer
  Best answer must be only one
} do
    given!(:user) { create(:user) }
    given!(:question) {create(:question, user: user)}
    given!(:other_user) { create(:user) }
    given!(:answer) {create(:answer, question: question, user: other_user)}

  scenario 'Author of the question see the link best' do
    sign_in user

    visit question_path(question)
    expect(page).to have_link 'Best'
  end

  scenario 'Author choose the best answer', js: true do
    sign_in user
    visit question_path(question)
    expect(page).to have_link 'Best'
    click_on 'Best'

    expect(page).to have_content 'The best answer'
  end
end
