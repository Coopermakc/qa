require_relative 'acceptance_spec'

feature 'Votes for answer', %q{
  In order to vote for answer
  As an uthenticated user
  I want to be able to vote for answer
  } do
    let(:user) { create(:user) }
    let(:author) { create(:user) }
    let!(:question) { create(:question, user_id: author.id) }
    let!(:answer) { create(:answer, user: author, question: question) }
  describe 'Authencticated user' do

    before do
      user.confirm
      sign_in user
      visit question_path(question)
    end
    scenario 'Authenticated user can vote', js: true do

      within('.answers') do
          click_on 'vote up'
          expect(page).to have_content '1'
      end
    end

    scenario 'Authenticated user can vote down', js: true do

      within('.answers') do
        click_on 'vote down'
        expect(page).to have_content '-1'
      end
    end
  end


  scenario 'Non-authenticated user can`t vote' do
    visit question_path(question)
    expect(page).to_not have_content 'vote up'
    expect(page).to_not have_content 'vote down'
  end
end
