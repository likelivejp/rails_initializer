rbenv gemset init
gem install rails -v 6.0.0
rails new . -B -C --database=postgresql --webpack -m https://raw.github.com/likelivejp/rails_initializer/master/template.rb
