rbenv gemset init
gem install rails -v 5.2.3
rails new . -B --database=postgresql --webpack=vue -m https://raw.github.com/likelivejp/rails_initializer/master/template.rb
