@repo_url = "https://raw.github.com/likelivejp/rails_initializer/master"
@app_name = app_name

run "rbenv local #{RUBY_VERSION}"

# 環境変数を.envに書くことで使えるようにする
gem "dotenv-rails"

# javascriptでi18n(多言語化)する時に
gem "i18n-js"

# 今開発環境だよってわかりやすく表示
gem "rack-dev-mark"

# webpackのコンパイルを開発時に自動化する
gem "foreman"
get "#{@repo_url}/Procfile", "Procfile"

# 開発、テストで必要なgemたち
gem_group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]

  # ダミーデータを簡単につくれる
  gem "faker"

  # 日本語のダミーデータを簡単につくれる
  gem "gimei"

  # デバッグのおとも
  gem "pry"

  # model.rbなどにdbスキーマをコメントで書いてくれる
  gem "annotate"

  # 基本的なセキュリティチェックをする
  gem "brakeman", require: false

  # HTTP通信を差し替える
  gem "webmock"

  # 外部APIダンプを作る
  gem "vcr"

  # 開発用のメールを受信、ブラウザで表示してくれる
  gem "letter_opener_web"
end

run "bundle install"

environment(<<-ENV, env: 'development')

  # webpackerがここに改行無しで追加してくるのでコメント追加
  config.rack_dev_mark.enable = true
  config.action_mailer.delivery_method = :letter_opener_web
ENV

environment(<<-ENV, env: 'test')
  config.action_mailer.default_url_options = { host: 'localhost:5000' }
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

# sorceryの初期設定を全て行う
gem "sorcery"
run "bundle install"
run "rails generate sorcery:install remember_me reset_password user_activation"
generate :scaffold, "User email:string crypted_password:string salt:string --migration false"
generate :controller, "UserSessions new create destroy"
generate :mailer, "UserMailer activation_needed_email activation_success_email"
generate :controller, "PasswordResets create edit update"
generate :mailer, "UserMailer reset_password_email"
replacement_files = %w(
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
)
replacement_files.each do |path|
  run "rm #{path}"
  get "#{@repo_url}/#{path}", path
end

# htmlメールを先に見に行ってしまうのでhtmlを削除
remove_files = %w(
  app/views/user_mailer/activation_needed_email.html.erb
  app/views/user_mailer/activation_success_email.html.erb
  app/views/user_mailer/reset_password_email.html.erb
)
remove_files.each do |path|
  run "rm #{path}"
end

# testファイルの転送
replace_test_files = %w(
  test/controllers/users_controller_test.rb
  test/controllers/password_resets_controller_test.rb
  test/controllers/user_sessions_controller_test.rb
  test/fixtures/users.yml
)
replace_test_files.each do |path|
  run "rm #{path}"
  get "#{@repo_url}/#{path}", path
end

after_bundle do
  run "curl https://www.gitignore.io/api/node%2Cmacos%2Crails > .gitignore"
  run "guard init minitest"
  rake "db:create"
  rake "db:migrate"
  run "bundle binstubs bundler --force"
  git :init
  git add: "."
  git commit: "-a -m 'rails new'"
end
