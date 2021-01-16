class ApplicationController < ActionController::Base
    include SessionsHelper
    
  private

  def require_user_logged_in
    unless logged_in?
      redirect_to login_url
    end
  end

# 全てのコントローラで counts(user) が使用できる。users_controllerのshowで使用。
  def counts(user)
    @count_taskss = user.tasks.count
  end
end
