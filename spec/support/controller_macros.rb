module ControllerMacros
  def sign_in_user
    before do
      @user = create(:user)
      @request.env['devise.mapping'] = Devise.mappings[:user]
      @user.confirm
      sign_in @user
    end
  end
  def sign_in_other
    before do
      @other = create(:user)
      @request.env['devise.mapping'] = Devise.mappings[:user]
      @other.confirm
      sign_in @other
    end
  end
end
