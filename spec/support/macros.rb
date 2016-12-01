# ====------------------------====
# Controller and Model Specs
# ====------------------------====

def set_user(user = nil, activated: true)
  user ||= Fabricate :user, activated: activated
  session[:user_id] = user.id
end

def clear_current_user
  session[:user_id] = nil
end

def current_user
  @current_user ||= begin
    User.find session[:user_id]
  rescue ActiveRecord::RecordNotFound
    nil
  end
end

def remember(user)
  user.remember
  cookies.permanent.signed[:user_id] = user.id
  cookies.permanent[:remember_token] = user.remember_token
end

# ====-----------------------------====
# Feature and Request Specs
# ====-----------------------------====

def login(user = Fabricate(:user))
  post login_path, username: user.username, password: user.password
end
