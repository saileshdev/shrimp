module SessionsHelper

  # logs in the user
  def log_in(user)
    session[:user_id] = user.id
  end

  # remeber a user in persistent sessions
  def remember(user)
    user.remember
    # set the cookies
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent.signed[:remember_token] = user.remember_token
  end

  #returns the current logged-in user
  def current_user
    if (user_id = session[:user_id])
      #if sessions still exists case
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      # if the session is lost, but persistent cookies still exist case
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # returns true if the given user is the current_user
  def current_user?(user)
    user == current_user
  end
  # returns true, if the user is logged in
  def logged_in?
    !current_user.nil?
  end

  #forgets a persistent user
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # logout the user
  def log_out
    forget(current_user)
    session[:user_id] = nil
    # or we can do, session.delete(:user_id)
    @current_user = nil
  end

  # redirects to stored location
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    #delete the URL once forwarding is done
    session.delete(:forwarding_url)
  end
  
  #store the URL trying to be accessed
  def store_location
    session[:forwarding_url] = request.url if request.get?
  end
end
