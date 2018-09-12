require_relative 'acceptance_spec'

feature 'Add file to question', %{
  User add file when create question
  } do
    given(:user) { create(:user) }
    background do
      user.confirm
      sign_in user
      visit new_question_path
      fill_in 'Title', with: 'Title of the question'
      fill_in 'Text', with: 'Body of the question'
    end

    scenario 'User adding file when create question', js: true do
      click_on 'Add'
      inputs = all('input[type="file"]')
      inputs[0].set("#{Rails.root}/spec/spec_helper.rb")
      inputs[1].set("#{Rails.root}/spec/rails_helper.rb")
      click_on 'Create'
      expect(page).to have_link "/uploads/attachment/file/2/rails_helper.rb", href: '/uploads/attachment/file/2/rails_helper.rb'
      expect(page).to have_link "/uploads/attachment/file/1/spec_helper.rb", href: '/uploads/attachment/file/1/spec_helper.rb'
    end

end
