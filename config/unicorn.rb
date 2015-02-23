worker_processes 2

listen '/tmp/unicorn.sock'  # 1
pid "/home/ec2-user/deploy/shared/tmp/pids/unicorn.pid" #2

stderr_path File.expand_path('unicorn.log', File.dirname(__FILE__) + '/../log')
stdout_path File.expand_path('unicorn.log', File.dirname(__FILE__) + '/../log')
preload_app true