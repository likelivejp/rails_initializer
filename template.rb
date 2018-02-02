@repo_url = "https://raw.github.com/likelivejp/rails_initializer/master"
@app_name = app_name

run "rbenv local #{RUBY_VERSION}"

# 環境変数を.envに書くことで使えるようにする
gem "dotenv-rails"

# javascriptでi18n(多言語化)する時に
gem "i18n-js"

# 今開発環境だよってわかりやすく表示
gem "rack-dev-mark"

# 開発用のメールを受信、ブラウザで表示してくれる

# webpackのコンパイルを開発時に自動化
gem "foreman"
get "#{@repo_url}/Procfile", "Procfile"

gem_group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "faker"
  gem "gimei"
  gem "pry"
  gem "annotate"
  gem "brakeman", require: false
  gem "webmock"
  gem "vcr"
  gem "letter_opener"
end

run "bundle install"

environment(<<-ENV, env: 'development')

  # webpackerがここに改行無しで追加してくるのでコメント追加
  config.rack_dev_mark.enable = true
  config.action_mailer.delivery_method = :letter_opener_web
ENV

application <<-APPLICATION_CONFIG
  config.i18n.default_locale = :ja
  config.time_zone = 'Tokyo'
  config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
  config.generators do |g|
    g.stylesheets false
    g.javascripts false
    g.helper false
    g.jbuilder false
  end
APPLICATION_CONFIG

gem "sorcery"
run "bundle install"
run "rails generate sorcery:install remember_me reset_password user_activation"
generate :scaffold, "User email:string crypted_password:string salt:string --migration false"
generate :controller, "UserSessions new create destroy"
generate :mailer, "UserMailer activation_needed_email activation_success_email"
generate :controller, "PasswordResets create edit update"
generate :mailer, "UserMailer reset_password_email"
%w(
  app/controllers/application_controller.rb
  app/controllers/users_controller.rb
  app/controllers/user_sessions_controller.rb
  app/controllers/password_resets_controller.rb
  app/models/user.rb
  app/views/layouts/application.html.erb
  app/views/users/_form.html.erb
  app/views/users/edit.html.erb
  app/views/users/index.html.erb
  app/views/users/new.html.erb
  app/views/users/show.html.erb
  app/views/user_sessions/_form.html.erb
  app/views/user_sessions/new.html.erb
  app/views/user_sessions/_forgot_password_form.html.erb
  app/views/password_resets/edit.html.erb
  app/views/user_mailer/activation_needed_email.text.erb
  app/views/user_mailer/activation_success_email.text.erb
  app/views/user_mailer/reset_password_email.text.erb
  app/mailers/user_mailer.rb
  config/initializers/sorcery.rb
  config/routes.rb
).each do |path|
  run "rm #{path}"
  get "#{@repo_url}/#{path}", path
end

after_bundle do
  run "curl https://www.gitignore.io/api/node%2Cmacos%2Crails > .gitignore"
  run "guard init minitest"
  rake "db:create"
  rake "db:migrate"
  ruby "bundle binstubs bundler --force"
  git :init
  git add: "."
  git commit: "-a -m 'rails new'"
end
