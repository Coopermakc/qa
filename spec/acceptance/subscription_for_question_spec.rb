require_relative 'acceptance_spec.rb'

feature 'User can subscribes and unsubscribes for question' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:user_2) { create(:user) }
  given(:question_2) { create(:question, user: user_2) }

  background do
    user.confirm
    sign_in user
  end

  scenario 'Auth user see the link Subscribe', js: true do
    visit question_path(question_2)
    expect(page).to have_link 'Subscribe'

    click_on 'Subscribe'

    expect(page).to_not have_link 'Subscribe'
    expect(page).to have_link 'Unsubscribe'
  end

  scenario 'If user have subscription for question he see link Unsubscribe', js: true do
    visit question_path(question)
    expect(page).to have_link 'Unsubscribe'

    click_on 'Unsubscribe'

    expect(page).to have_link 'Subscribe'
    expect(page).to_not have_link 'Unsubscribe'
  end
end
