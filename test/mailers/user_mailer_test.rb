require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "account_activation" do
    user = User.create(name: "Test User", email: "test@example.com",
                       password: "foobar", password_confirmation: "foobar")
    mail = UserMailer.account_activation(user)
    assert_equal 'ControverSciences : Confirmation de création d\'un compte', mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@controversciences.fr"], mail.from
    assert_match user.name,               mail.body.encoded
    assert_match user.activation_token,   mail.body.encoded
    assert_match CGI::escape(user.email), mail.body.encoded
  end

  test "password_reset" do
    user = users(:thibault)
    user.create_reset_digest
    mail = UserMailer.password_reset(user)
    assert_equal 'ControverSciences : Réinitialisation du mot de passe', mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@controversciences.fr"], mail.from
    assert_match user.reset_token,        mail.body.encoded
    assert_match CGI::escape(user.email), mail.body.encoded
  end
end
