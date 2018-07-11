require_relative 'acceptance_spec'

feature 'Edit answer', %q{
  In order to correct text an answer
  As an author of the question
  User can be able to edit answer
  } do

      given(:user) { create(:user) }
      given!(:question) { create(:question, user: user) }
      given!(:answer) { create(:answer, question: question, user: user) }

      scenario 'Non-authenticated user try to edit answer' do
        visit question_path(question)

        expect(page).to_not have_link 'Edit'
      end
      describe 'Authenticated user' do
        before do
          sign_in(user)
          visit question_path(question)
        end
        scenario 'sees link to edit' do
          within '.answers' do
            expect(page).to have_link 'Edit'
          end
        end

        scenario 'try edit his answer', js: true do
          click_on 'Edit'

          within '.answers' do
            fill_in 'Answer', with: 'edited answer'
            click_on 'Save'
            expect(page).to_not have_content answer.body
            expect(page).to have_content 'edited answer'
            expect(page).to_not have_selector 'textarea'
          end

        end

        scenario 'user ties to edit alien answer' do
        end
      end
  end
