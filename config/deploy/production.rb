set :stage, :production
set :branch, 'master'
set :rails_env, 'production'
set :unicorn_rack_env, 'production'

role :app, %w{ec2-user@｛EC2インスタンスのIPアドレス｝}
role :web, %w{ec2-user@｛EC2インスタンスのIPアドレス｝}
role :db,  %w{ec2-user@｛EC2インスタンスのIPアドレス｝}

server '{EC2インスタンスのIPアドレス}', user: 'ec2-user', roles: %w{web app db}

set :ssh_options, {
    keys: [File.expand_path('{EC2インスタンス接続用pemファイルのパス}')],
    forward_agent: true,
    auth_methods: %w(publickey)
}