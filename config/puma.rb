rails_root = `pwd`.chomp
workers 2
threads(0, 16)
bind      "unix:#{rails_root}/tmp/sockets/puma.sock"
pidfile     "#{rails_root}/tmp/pids/puma.pid"
activate_control_app
