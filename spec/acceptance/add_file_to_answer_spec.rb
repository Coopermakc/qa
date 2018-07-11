require_relative 'acceptance_spec'

feature 'User can add file to answer', %q{
  User can add file when create answer
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  background do
   sign_in user
   visit question_path(question)
  end
  scenario 'User add file to answer', js: true do
    fill_in 'Your answer', with: 'Body of the answer'
    click_on 'Add'
    all('input[type="file"]')[0].set("#{Rails.root}/spec/spec_helper.rb")
    click_on 'Add'
    all('input[type="file"]')[1].set("#{Rails.root}/spec/spec_helper.rb")
    click_on 'Create'

    within '.answers'do
      expect(page).to have_link href: '/uploads/attachment/file/1/spec_helper.rb'
      expect(page).to have_link href: '/uploads/attachment/file/2/spec_helper.rb'
    end
  end

end
