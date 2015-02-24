# coding: utf-8

txt = <<-TXT

      ＿人人人人人人人人人人人人人人人＿
      ＞　Rails Application Templates　＜
      ￣Y^Y^Y^Y^Y^Y^Y^Y^Y^Y^Y^Y^Y^YY^Y￣

TXT
puts txt

# Define
# ----------------------------------------------------------------
repo_url = "https://raw.githubusercontent.com/jikuya/rails_template/master"


# Gem
# ----------------------------------------------------------------
# フォームを簡潔にかける
gem 'simple_form'
# モデルの検索インターフェースを簡単に作れる
gem 'ransack'
# ページング
gem 'kaminari'
# モデルが持っているデータを表示するためのメソッドを定義するレイヤーを作ることができる
gem 'active_decorator'
# 静的データのモデル化
gem 'active_hash'
# 論理削除
gem 'paranoia'
# Classの状態遷移をスマートに実装する
gem 'aasm'
# 画像アップローダー
gem 'carrierwave'
# Sessionの保存先をActiveRecordにする
gem 'activerecord-session_store'

# Twitter Boot Strap
use_bootstrap = if yes?('Use Bootstrap?')
                  uncomment_lines 'Gemfile', "gem 'therubyracer'"
                  gem 'less-rails'
                  gem 'twitter-bootstrap-rails'
                  true
                else
                  false
                end

# Unicorn
use_unicorn = if yes?('Use unicorn?')
                uncomment_lines 'Gemfile', "gem 'unicorn'"
                true
              else
                false
              end

# 認証管理
use_devise = if yes?('Use devise?')
               gem 'devise'
               gem 'devise-i18n'
               gem 'devise-i18n-views'

               devise_model = ask 'Please input devise model name. ex) User, Admin: '
               true
             else
               false
             end

# ジョブキューイング
use_delayed_job_active_record = if yes?('Use delayed_job_active_record?')
                                  gem 'delayed_job'
                                  gem 'delayed_job_active_record'
                                  gem "daemons"
                                  true
                                else
                                  false
                                end

# ユーザーの権限管理
use_cancancan = if yes?('Use cancancan?')
                  gem 'cancancan'
                  true
                else
                  false
                end

# Heroku
use_heroku = if yes?('Use heroku?')
               true
             else
               false
             end

# Capistrano
use_capistrano = if yes?('User deploy with capistrano?')
                  true
                else
                  false
                end

gem_group :production do
  if use_heroku
    # Postgresql
    gem 'pg'
    # HerokuへのDeployに必要
    gem 'rails_12factor'
  else
    # MySQL
    gem 'mysql2'
  end
end

gem_group :development, :test do
  # アプリケーションのバックグラウンドで動作し、アプリケーション起動時のもろもろの動作をサポート
  gem 'spring'
  # rails consoleをirbではなくpryにしてくれる
  gem 'pry-rails'
  # pry上でクラスやメソッドなどのドキュメントや定義元のソースコードを確認できる
  gem 'pry-doc'
  # ブレークポイントを仕込める
  gem 'pry-byebug'
  # スタックの情報が見られる
  gem 'pry-stack_explorer'
  # Rails用のRSpecテスティングフレームワーク
  gem 'rspec-rails'
  # RspecをSpringで起動できるようにする
  gem 'spring-commands-rspec', '~> 1.0.4'
  # テストデータ生成
  gem 'factory_girl_rails'
  # rspecを実行するためにGuardファイルウォッチャ
  gem 'guard-rspec'
  # APIドキュメント自動生成
  gem 'autodoc'
  # End to End Test FrameWork
  gem 'capybara'
  # Rails Console 上で ActiveRecord の結果を見やすくする
  gem 'hirb'
  gem 'hirb-unicode'
  # エラー画面をわかりやすく整形してくれる
  gem 'better_errors'
  # better_errorsの画面上にirb/pry(PERL)を表示する
  gem 'binding_of_caller'
  # オブジェクトの中身をきれいに見る
  gem 'awesome_print'
end

gem_group :development do
  if use_capistrano
    gem 'capistrano-rails'
    gem 'capistrano-rbenv'
    gem 'capistrano-bundler'
    gem 'capistrano3-unicorn'
  end
  #メールが送信されたときにブラウザでメールを確認することが出来る
  gem 'letter_opener'
  # 簡易プロファイラ
  gem 'rack-mini-profiler'
  # N+1問題の警告を出力
  gem 'bullet'
  # Railsのコード解析ツール
  gem 'rails_best_practices'
end

gem_group :test do
  # 便利マッチャー集
  gem "shoulda-matchers"
  # JSON用マッチャー
  gem 'json_spec'
  # JSON出力をテスト
  gem 'json_expressions'
  # テスト内で時間を自由に操作できる
  gem 'timecop'
  # Capybaraでテスト中に現在のページをブラウザで開ける
  gem 'launchy'
end

# Bundle Install
# ----------------------------------------------------------------
run 'bundle install --path vendor/bundle --without production'


# Application settings (includeing Japanize)
# ----------------------------------------------------------------
application do
  %q{
    config.active_record.default_timezone = :local
    config.time_zone = 'Tokyo'
    config.i18n.default_locale = :ja

    config.generators do |g|
      g.orm :active_record
      g.test_framework :rspec, fixture: true, fixture_replacement: :factory_girl
      g.view_specs false
      g.controller_specs false
      g.routing_specs false
      g.helper_specs false
      g.request_specs false
      g.assets false
      g.helper false
    end

    config.autoload_paths += %W(#{config.root}/lib)
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
  }
end
get "#{repo_url}/config/locales/ja.yml", 'config/locales/ja.yml'


# Create directories
# ----------------------------------------------------------------
empty_directory_with_keep_file 'app/decorators'


# Environment setting
# ----------------------------------------------------------------
comment_lines 'config/environments/production.rb', "config.serve_static_files = ENV['RAILS_SERVE_STATIC_FILES'].present?"
environment 'config.serve_static_files = true', env: 'production'
environment 'config.action_mailer.delivery_method = :letter_opener', env: 'development'


# .gitignore settings
# ----------------------------------------------------------------
remove_file '.gitignore'
create_file '.gitignore' do
  body = <<EOS
# Ignore bundler config.
/.bundle

# Ignore the default SQLite database.
/db/*.sqlite3
/db/*.sqlite3-journal

# Ignore all logfiles and tempfiles.
/log/*
!/log/.keep
/tmp

# Gemlock.lockとvendor/bundleをgitの管理から外す
/*.lock
/vendor/bundle
EOS
end


# Root path settings
# ----------------------------------------------------------------
if yes?('Generate root path to home#index?')
  generate 'controller', 'home index'
  route "root to: 'home#index'"
end


# RSpec setting
# ----------------------------------------------------------------
generate 'rspec:install'
remove_dir 'test'
if use_devise
  uncomment_lines 'spec/spec_helper.rb', 'include Warden::Test::Helpers'
  uncomment_lines 'spec/spec_helper.rb', 'config.include Devise::TestHelpers, type: :controller'
  uncomment_lines 'spec/spec_helper.rb', 'config.include Devise::TestHelpers, type: :view'
  uncomment_lines 'spec/spec_helper.rb', 'Warden.test_mode!'
  uncomment_lines 'spec/spec_helper.rb', 'Warden.test_reset!'
  generate 'devise:install'
end

if use_cancancan
  generate 'cancan:ability'
end

remove_file '.rspec'
create_file '.rspec' do
  body = <<EOS
--colour
--format documentation
EOS
end


# bullet settings
# ----------------------------------------------------------------
insert_into_file 'config/environments/development.rb',
%(
  # Bulletの設定
  config.after_initialize do
    Bullet.enable = true # Bulletプラグインを有効
    Bullet.alert = true # JavaScriptでの通知
    Bullet.bullet_logger = true # log/bullet.logへの出力
    Bullet.console = true # ブラウザのコンソールログに記録
    Bullet.rails_logger = true # Railsログに出力
  end
),
after: 'config.assets.debug = true'


# Initialize Twitter Bootstrap and SimpleForm and Kaminari
# ----------------------------------------------------------------
if use_bootstrap
  generate 'bootstrap:install', 'less'
  generate 'simple_form:install', '--bootstrap'
  generate 'kaminari:config'
  generate 'kaminari:views bootstrap3'
  if yes?("Use responsive layout?")
    remove_file 'app/views/layouts/application.html.erb'
    generate 'bootstrap:layout', 'application fluid'
  else
    remove_file 'app/views/layouts/application.html.erb'
    generate 'bootstrap:layout', 'application fixed'
    append_to_file 'app/assets/stylesheets/application.css' do
      "body { padding-top:60px }"
    end
  end
  get "#{repo_url}/config/locales/ja.bootstrap.yml", 'config/locales/ja.bootstrap.yml'
else
  generate 'simple_form:install'
  generate 'kaminari:config'
end
get "#{repo_url}/config/locales/simple_form.ja.yml", 'config/locales/simple_form.ja.yml'


# Initialize activerecord-session_store
# ----------------------------------------------------------------
generate 'active_record:session_migration'
remove_file 'config/initializers/session_store.rb'
get "#{repo_url}/config/initializers/session_store.rb", 'config/initializers/session_store.rb'


# Database settings
# ----------------------------------------------------------------
run "cp config/database.yml config/database.yml.sample"
remove_file 'config/database.yml'

if use_heroku
  # pg
  get "#{repo_url}/config/database/pg.yml", 'config/database.yml'
else
  # mysql2
  get "#{repo_url}/config/database/mysql2.yml", 'config/database.yml'
  run "sed -i -e \"s/APP_NAME/#{app_name}/g\" config/database.yml"
end


# Migrate Database
# ----------------------------------------------------------------
rake 'db:drop'
rake 'db:create'
rake 'db:migrate'


# Git First Commit
# ----------------------------------------------------------------
git :init
git add: "."
git commit: %Q{ -m 'Initial commit' }


# Initialize Devise Model
# ----------------------------------------------------------------
if use_devise
  # Mail setting
  environment "config.action_mailer.default_url_options = { host: 'localhost:3000' }", env: 'development'
  # Generate Model
  generate "devise #{devise_model}"
  # Generate View
  generate 'devise:views'
  # Japanize View
  generate 'devise:views:locale ja'
  get "#{repo_url}/config/locales/devise.ja.yml", 'config/locales/devise.ja.yml'
  # Optional Devise Setting
  if yes?('Need setting of Confirmable and Lockable?')
    remove_file 'config/initializers/devise.rb'
    get "#{repo_url}/config/initializers/devise.rb", 'config/initializers/devise.rb'
    devise_model_name = devise_model.underscore
    insert_into_file "app/models/#{devise_model_name}.rb",
                      %(,\n         :confirmable, :lockable\n),
                      after: ":recoverable, :rememberable, :trackable, :validatable"
    migration_file = `ruby -e 'print Dir.glob("db/migrate/*devise_create_users*")[0]'`
    uncomment_lines migration_file, "t.string   :confirmation_token"
    uncomment_lines migration_file, "t.datetime :confirmed_at"
    uncomment_lines migration_file, "t.datetime :confirmation_sent_at"
    uncomment_lines migration_file, "t.string   :unconfirmed_email # Only if using reconfirmable"
    uncomment_lines migration_file, "t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts"
    uncomment_lines migration_file, "t.string   :unlock_token # Only if unlock strategy is :email or :both"
    uncomment_lines migration_file, "t.datetime :locked_at"
    uncomment_lines migration_file, "add_index :users, :confirmation_token,   unique: true"
    uncomment_lines migration_file, "add_index :users, :unlock_token,         unique: true"
  end
  # Change path
  if yes?('Change the authorize path name? (Default is users)')
    path_name = ask 'Please input path name. ex) auth : '
    insert_into_file "config/routes.rb",
                      %(, :path => "#{path_name}"),
                      after: "devise_for :users"
  end
  # Migrate Database
  rake 'db:migrate'
  # Git Commit
  git add: "."
  git commit: %Q{ -m 'Add devise model and views.' }
end


# Initialize DelayedJob with ActiveRecord
# ----------------------------------------------------------------
if use_delayed_job_active_record
  # Generate DelayedJob's Schema
  generate 'delayed_job:active_record'
  rake 'db:migrate'
  # DeleyedJob setting
  get "#{repo_url}/config/initializers/delayed_job_config.rb", 'config/initializers/delayed_job_config.rb'
  # Git Commit
  git add: "."
  git commit: %Q{ -m 'Setting delayed_job_active_record' }
end


# Capistrano settings
# ----------------------------------------------------------------
if use_capistrano
  # Deploy settings
  get "#{repo_url}/Capfile", 'Capfile'
  get "#{repo_url}/config/deploy.rb", 'config/deploy.rb'
  empty_directory 'config/deploy'
  get "#{repo_url}/config/deploy/production.rb", 'config/deploy/production.rb'
  # Git Commit
  git add: "."
  git commit: %Q{ -m 'Setting deploy with capistrano' }
  # Remain Tasls
  say "ProductinoにDeployするまでの残タスクは以下の通りです。"
  say "  'Productino用のサーバーを準備して下さい。"
  say "  'config/deploy.rb'の'application'と'repo_url'は各自のアプリ環境に合わせて変えて下さい。"
  say "  'config/deploy/production.rb'の日本語でコメントのある所は各自のアプリ環境に合わせて変えて下さい。"
  say "  'config/database.yml'の'username'と'password'と'host'は適宜編集して下さい。。"
  say "  'config/secrets.yml'のProductionの設定をして下さい。"
end

exit
