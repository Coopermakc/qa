class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def github
    logger.info(request.env["omniauth.auth"].to_json)
    oauth_provider(:github)
  end

  private

  def oauth_provider(provider)
    @user = User.from_omniauth(auth)
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider.to_s.humanize) if is_navigational_format?
    else
      flash[:notice] = 'Insert your email, please.'
      session["device.autn"] = { provider: request.env['omniauth.auth'].provider,
                                  uid: request.env['omniauth.auth'].uid }
      render 'users/confirm_user_email'
    end
  end
  def auth
    request.env['omniauth.auth'] || OmniAuth::AuthHash.new(params[:auth].merge!(session['devise.auth']))
  end
end
