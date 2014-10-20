rails_root = `pwd`.chomp
bind        "unix:#{rails_root}/tmp/sockets/puma.sock"
pidfile     "#{rails_root}/tmp/pids/puma.pid"
state_path  "#{rails_root}/tmp/puma.state"
activate_control_app
