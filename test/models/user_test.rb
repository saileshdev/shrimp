require 'test_helper'

class UserTest < ActiveSupport::TestCase
 
  def setup
  #this setup method runs before every test 
    @user = User.new(name: "Example User", email: "user@example.com", 
                    password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "    "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end


  test "email should be present" do
    @user.email = "    "
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 256
    assert_not @user.valid?
  end

  test "email validation should accept valid formats" do
    valid_addresses = %w[user@example.com USER@example.COM A_US-EN@foo.bar.org 
    first.last@foo.jp mike+bob@baz.cn]
    
    valid_addresses.each do |valid_address|
       @user.email = valid_address
       assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid formats" do
    invalid_addresses = %w[user@example,com user_at_bar.com user.name@example.
    foo@bar_baz.com foo@bar+baz.com]
    
    invalid_addresses.each do |invalid_address|
       @user.email = invalid_address
       assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"

    end
  end

  test "email address should be unique" do
    duplicate_user =  @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email address user@example.com and USER@example.com should be treated the same" do
    duplicate_user =  @user.dup
    duplicate_user.email =  @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, "some_token_value")
  end

  test "associated microposts should be destroyed" do
    #@user is just created in memory so lets save it to db
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference "Micropost.count", -1 do
      @user.destroy
    end
  end
 
end
