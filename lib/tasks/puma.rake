namespace :puma do
  desc "Start puma"
  task(:start) do
    config = Rails.root.join("config", "puma.rb")
    env    = ENV['RAILS_ENV'] || "development"
    `bundle exec puma -d -C #{config} -e #{env}`
  end

  desc "Halt puma"
  task(:halt) { puts `bundle exec pumactl -p #{puma_pid} restart` }

  desc "Restart puma"
  task(:restart) { puts `bundle exec pumactl -p #{puma_pid} restart` }

  desc "Phased-restart puma"
  task(:phased_restart) { puts `bundle exec pumactl -p #{puma_pid} phased-restart` }

  desc "Stats puma"
  task(:stats) { puts `bundle exec pumactl -p #{puma_pid} stats` }

  desc "Status puma"
  task(:status) { puts `bundle exec pumactl -p #{puma_pid} status` }

  desc "Stop puma"
  task(:stop) { puts `bundle exec pumactl -p #{puma_pid} stop` }

  def puma_pid
    begin
      pid = File.read( Rails.root.join("tmp", "pids", "puma.pid") ).to_i
      return pid if Process.getpgid( pid )
    rescue
      puts "Puma doesn't seem to be running"
      exit
    end
  end
end
