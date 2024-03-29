require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
  #we are clearing the array before any test
  ActionMailer::Base.deliveries.clear
  #ActionMailer::Base.deliveries is an array and the length becomes 1 when a mail is sent 
  end
  
  test "invalid signup information" do
    get signup_path
   
    assert_no_difference 'User.count' do 
    post users_path, user: {name: "",email: "user@invalid", password: "foo", password_confirmation: "bar"}
    
    end
    
    assert_template "users/new"  
  end


  test "valid signup information" do
    get signup_path
   
    assert_difference 'User.count',1 do 
    post users_path, user: {name: "Example user",email: "user@example.com", password: "password", password_confirmation: "password"}
    end

    assert_equal 1, ActionMailer::Base.deliveries.size
    
    user = assigns(:user) #this gets the instance variable @user from the create action
    assert_not user.activated?

    #try to log in before activation
    log_in_as(user)
    assert_not is_logged_in?

    #invalid activation token
    get edit_account_activation_path("invalid token")
    assert_not is_logged_in?
     
    get edit_account_activation_path(user.activation_token, email: "invalid_email")
    assert_not is_logged_in?
    
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template "users/show" 
    assert is_logged_in?
  end

end
