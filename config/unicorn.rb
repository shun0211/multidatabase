rails_root = File.expand_path('..', __dir__)
working_directory rails_root
puts rails_root

worker_processes 2
preload_app true
puts 'aa'
listen "#{rails_root}/tmp/unicorn.sock"
pid "#{rails_root}/tmp/unicorn.pid"
puts 'bb'
#ログの出力先を指定
# stderr_path "#{rails_root}/log/unicorn_error.log"
# stdout_path "#{rails_root}/log/unicorn.log"

# before_fork do |_server, _worker|
#   ActiveRecord::Base.connection.disconnect! if defined? ActiveRecord::Base
# end

# after_fork do |_server, _worker|
#   ActiveRecord::Base.establish_connection if defined? ActiveRecord::Base
# end
