require_relative 'acceptance_spec'

feature 'User edit qiestion', %q{
  User can edit his question
  As an author of the question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Non-authenticated user can`t see link edit' do
    visit question_path(question)
    expect(page).to_not have_link 'Edit question'
  end
  describe 'Authenticated user' do
    before do
      user.confirm
      sign_in user
      visit question_path(question)
    end
    scenario 'Author see link Edit question' do
      expect(page). to have_link 'Edit question'
    end
  end

end
