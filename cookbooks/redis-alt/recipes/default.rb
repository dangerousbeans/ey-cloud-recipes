#
# Cookbook Name:: redis
# Recipe:: default
#

package "dev-db/redis" do
  action :purge
end

require_recipe "redis::compile_from_source"

storage_dir = case node[:instance_role]
  when "db_master", "db_slave", "solo" then "/db"
  else "/data"
end

directory "#{storage_dir}/redis" do
  owner "redis"
  group "redis"
  mode 0750
end

template "/etc/redis.conf" do
  source "redis.conf.erb"
  owner "redis"
  group "redis"
  mode 0640
  variables(
    :bind      => "0.0.0.0",
    :port      => 6379,
    :timeout   => 300,
    :databases => 16,
    :dir       => "#{storage_dir}/redis",
    :pidfile   => "/var/run/redis/redis.pid",
    :logfile   => "/var/log/redis/redis.log",
    :loglevel  => "notice"
  )
  backup false
end

execute "enable vm.overcommit_memory" do
  command "sysctl vm.overcommit_memory=1"
end

service "redis" do
  supports :restart => true, :status => true
  action :start
end
