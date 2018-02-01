@app_name = app_name

yes? "Would you init rbenv gemset?" do
  run "rbenv gemset init"
end

yes? "Would you init rbenv local?" do
  run "rbenv local #{RUBY_VERSION}"
end

# 環境変数を.envに書くことで使えるようにする
gem 'dotenv-rails'

# javascriptでi18n(多言語化)する時に
gem 'i18n-js'

# 今開発環境だよってわかりやすく表示
gem 'rack-dev-mark'

# ユーザー認証系ライブラリ
@sorcery = yes? "Would you like to install sorcery?"
if @sorcery
  gem 'sorcery'
end

gem_group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'faker'
  gem 'gimei'
  gem 'pry'
  gem 'annotate'
  gem 'brakeman', require: false
  gem 'letter_opener_web'
end

after_bundle do
  run 'curl https://www.gitignore.io/api/macos%2Crails > .gitignore'
  run 'guard init minitest'
  # run 'guard init rails_best_practices' TODO 検討中

  run 'rails generate sorcery:install remember_me reset_password' if @sorcery
  git :init
  git add: '.'
  git commit: "-a -m 'Init commit'"
end
