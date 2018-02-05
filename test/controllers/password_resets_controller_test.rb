require 'test_helper'

class PasswordResetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:mario)
  end

  test "reset_password_email" do
    post password_resets_url, params: {
      email: @user.email
    }
    mail = UserMailer.reset_password_email(@user)
    assert_equal "Your password has been reset", mail.subject
    assert_equal ["#{@user.email}"], mail.to
    # app/mailers/application_mailer.rbの項目を↓に設定する
    # fromを設定したらココが落ちるのですぐに分かる
    assert_equal ["from@example.com"], mail.from
    assert_match "You have requested to reset your password.", mail.body.encoded
  end
end
