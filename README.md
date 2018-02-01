# Rails initializer

rails newする時に普段使うgemとか設定が面倒なので、ApplicationTemplateにまとめておきます。

開発する時に「これ毎回使ってる」と気づいた物があったらapp_template.rbに追加したい。

あとAPI専用のテンプレートが欲しくなったらブランチ生やすか、別のリポジトリ作るなどする。

## Usage

```
$ rails new YOUR_APP_NAME -B -d postgresql --webpack=vue -m https://raw.github.com/likelivejp/rails_initializer/master/app_template.rb
```
