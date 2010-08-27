#
# Cookbook Name:: redis
# Recipe:: default
#

package "dev-db/redis" do
  action :install
end

directory "/data/redis" do
  owner "redis"
  group "redis"
  mode 0755
  recursive true
end

# Overwrite the package binaries if the redis source code is newer
require_recipe "redis::compile_from_source"

template "/etc/redis.conf" do
  mode 0644
  source "redis.conf.erb"
  variables(
    :pidfile   => "/var/run/redis.pid",
    :port      => "6379",
    :bind      => "0.0.0.0",
    :timeout   => 300,
    :loglevel  => "notice",
    :logfile   => "/data/redis/redis.log",
    :databases => "16",
    :dir       => "/data/redis"
  )
end

execute "enable vm.overcommit_memory" do
  command "sysctl vm.overcommit_memory=1"
end

service "redis" do
  supports :restart => true, :status => true
  action :start
end
