@repo_url = "https://raw.github.com/likelivejp/rails_initializer/master"
@app_name = app_name

yes? "Would you init rbenv gemset?" do
  run "rbenv gemset init"
end

yes? "Would you init rbenv local?" do
  run "rbenv local #{RUBY_VERSION}"
end

# 環境変数を.envに書くことで使えるようにする
gem "dotenv-rails"

# javascriptでi18n(多言語化)する時に
gem "i18n-js"

# 今開発環境だよってわかりやすく表示
gem "rack-dev-mark"

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
  gem "letter_opener_web"
  gem "webmock"
  gem "vcr"
end

run "bundle install"

application <<-APPLICATION_CONFIG
config.generators do |g|
  g.stylesheets false
  g.javascripts false
  g.helper false
  g.jbuilder false
end
APPLICATION_CONFIG

gem "sorcery"
run "bundle install"
run "rails generate sorcery:install remember_me reset_password"
generate :scaffold, "email:string crypted_password:string salt:string --migration false"
generate :controller, "UserSessions new create destroy"
%w(
  app/controllers/users_controller.rb
  app/controllers/user_sessions_controller.rb
  app/models/user.rb
  app/views/layouts/application.html.erb
  app/views/users/_form.html.erb
  app/views/users/edit.html.erb
  app/views/users/index.html.erb
  app/views/users/new.html.erb
  app/views/users/show.html.erb
).each do |path|
  run "rm #{path}"
  get "#{@repo_url}/#{path}", path
end

after_bundle do
  run "curl https://www.gitignore.io/api/macos%2Crails > .gitignore"
  run "guard init minitest"
  rake "db:create"
  rake "db:migrate"
  git :init
  git add: "."
  git commit: "-a -m 'rails new'"
end
