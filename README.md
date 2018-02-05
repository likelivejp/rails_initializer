# Rails initializer

![](https://img.shields.io/badge/Rails-5.1.4-red.svg?style=flat-square)

rails newする時に普段使うgemとか設定が面倒なので、ApplicationTemplateにまとめておきます。

開発する時に「これ毎回使ってる」「最初の設定、何回もやって辛い」となったらtemplate.rbに追加しよう。

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
- letter_opener_web(Initialized)

## Usage

```
$ mkdir YOUR_APP_NAME && cd $_ && yes | sh -c "$(curl -fsSL https://raw.github.com/likelivejp/rails_initializer/master/initializer.sh)"
```

あとは`foreman start`ですぐに起動、開発できます🚀

## 参考

- [Rails のアプリケーションテンプレート](https://railsguides.jp/rails_application_templates.html)
