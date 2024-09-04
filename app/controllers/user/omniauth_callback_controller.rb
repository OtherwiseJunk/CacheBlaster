class User::OmniauthCallbackController < ApplicationController
  def discord
    @user = User.from_omniauth(request.env["omniauth.auth"])

    sign_in(:account, @user)

    redirect_to root_path
  end
end
