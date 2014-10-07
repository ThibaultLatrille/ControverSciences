require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:thibault)
  end

  test "password_reset" do
    get new_password_reset_path
    # Invalid submission
    post password_resets_path, password_reset: { email: "" }
    assert_template 'password_resets/new'
    # Valid submission
    post password_resets_path, password_reset: { email: @user.email }
    assert_redirected_to root_url
    # Get the user from the create action.
    user = assigns(:user)
    follow_redirect!
    assert_select 'div.alert'
    assert_equal 1, ActionMailer::Base.deliveries.size
    # Wrong email
    get edit_password_reset_path(user.reset_token, email: 'wrong')
    assert_redirected_to root_url
    # Right email, wrong token
    get edit_password_reset_path('wrong token', email: user.email)
    assert_redirected_to root_url
    # Right email, right token
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select "input#email[name=email][type=hidden][value=?]", user.email
    # Invalid password & confirmation
    patch password_reset_path(user.reset_token),
          email: user.email,
          user:  { password:              "foobaz",
                   password_confirmation: "barquux" }
    assert_select 'div#error_explanation'
    # Blank password & confirmation
    patch password_reset_path(user.reset_token),
          email: user.email,
          user:  { password:              "",
                   password_confirmation: "" }
    assert_not_nil flash.now
    assert_template 'password_resets/edit'
    # Valid password & confirmation
    patch_via_redirect password_reset_path(user.reset_token),
                       email: user.email,
                       user: { password:              "foobaz",
                               password_confirmation: "foobaz" }
    assert_template 'users/show'
  end
end