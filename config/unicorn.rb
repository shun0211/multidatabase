rails_root = File.expand_path('..', __dir__)
working_directory rails_root

worker_processes 2
preload_app true

listen "#{rails_root}/tmp/unicorn.sock"
pid "#{rails_root}/tmp/unicorn.pid"

# ログの出力先を指定
# これをするとCloud Watchにログが出なくなる
# stderr_path "#{rails_root}/log/unicorn_error.log"
# stdout_path "#{rails_root}/log/unicorn.log"
