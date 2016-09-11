require 'test_helper'

class UserTest < ActiveSupport::TestCase
 
  def setup
  #this setup method runs before every test 
    @user = User.new(name: "Example User", email: "user@example.com")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "    "
    assert_not @user.valid?
  end



end