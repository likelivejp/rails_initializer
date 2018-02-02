# Rails initializer

![](https://img.shields.io/badge/Rails-5.1.4-red.svg?style=flat-square)

rails newする時に普段使うgemとか設定が面倒なので、ApplicationTemplateにまとめておきます。

開発する時に「これ毎回使ってる」と気づいた物があったらapp_template.rbに追加したい。

あとAPI専用のテンプレートが欲しくなったらブランチ生やすか、別のリポジトリ作るなどする。

## Dependencies

- ruby
- rbenv

## Template content

### Main

- Rails 5.1.4
- Postgresql
- vue.js

### Gems

- dotenv-rails
- i18n-js
- rack-dev-mark(Initialized)
- foreman
- sorcery(Initialized)
  - Resister
  - Activate
  - RememberMe
  - ForgotPassword
- faker
- gimei
- pry
- annotate
- brakeman
- webmock
- vcr
- letter_opener(Initialized)

## Usage

```
$ mkdir YOUR_APP_NAME && cd $_ && ruby -e "$(curl -fsSL https://raw.github.com/likelivejp/rails_initializer/master/initializer.sh)"
```
## 参考

- [Rails のアプリケーションテンプレート](https://railsguides.jp/rails_application_templates.html)
