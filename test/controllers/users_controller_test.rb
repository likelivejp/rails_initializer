require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  include Sorcery::TestHelpers::Rails::Integration
  include Sorcery::TestHelpers::Rails::Controller

  setup do
    @user = users(:mario)
  end

  test "should get index" do
    get users_url
    assert_response :success
  end

  test "should get new" do
    get new_user_url
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post users_url, params: {
        user: {
          email: Faker::Internet.email,
          password: Faker::Internet.password,
        }
      }
    end
    assert_redirected_to login_path
  end

  test "should show user" do
    get user_url(@user)
    assert_response :success
  end

  test "should not get edit non-login user" do
    get edit_user_url(@user)
    assert_response :redirect
  end

  test "should not update non-login user" do
    # patch user_url(@user), params: { user: { crypted_password: @user.crypted_password, email: @user.email, salt: @user.salt } }
    patch user_url(@user), params: { user: { } }
    assert_response :redirect
  end

  test "should not destroy non-login user" do
    delete user_url(:ja, @user)
    assert_response :redirect
  end
end
