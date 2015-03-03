module RequestHelpers
  def login(user)
    login_as user, scope: :user, :run_callbacks => false
  end
end