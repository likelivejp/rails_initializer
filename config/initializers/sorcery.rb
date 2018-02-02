# The first thing you need to configure is which modules you need in your app.
# The default is nothing which will include only core features (password encryption, login/logout).
# Available submodules are: :user_activation, :http_basic_auth, :remember_me,
# :reset_password, :session_timeout, :brute_force_protection, :activity_logging, :external
Rails.application.config.sorcery.submodules = [:remember_me, :reset_password, :user_activation]

# Here you can configure each submodule's features.
Rails.application.config.sorcery.configure do |config|
  config.user_config do |user|
    user.user_activation_mailer = UserMailer
    user.reset_password_mailer = UserMailer
  end
  config.user_class = 'User'
end
