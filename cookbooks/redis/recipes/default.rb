#
# Cookbook Name:: redis
# Recipe:: default
#

if ['util'].include?(node[:instance_role])

  directory "/engineyard/portage/packages" do
    action :create
    owner "root"
    group "root"
    mode 0755
  end

  directory "/engineyard/portage/packages/dev-db" do
    action :create
    owner "root"
    group "root"
    mode 0755
  end
  
  packages_to_install = ['dev-db/redis-2.0.1.tbz2'].each do |packages_to_fetch|
    remote_file "/engineyard/portage/packages/#{packages_to_fetch}" do
      source "http://ey-portage.s3.amazonaws.com/#{node[:kernel][:machine]}/#{packages_to_fetch}"
      backup false
      not_if  { FileTest.exists?("/usr/share/doc/redis-2.0.0/BUGS.bz2") }
    end
  end
  
  execute "set_overcommit_memory" do
    command "echo 1 > /proc/sys/vm/overcommit_memory"
    action :run
  end

  execute "install_redis_2.0" do
    command "emerge /engineyard/portage/packages/dev-db/redis-2.0.1.tbz2"
    not_if { FileTest.exists?("/usr/share/doc/redis-2.0.1/BUGS.bz2") }
  end

  directory "/data/redis" do
    owner 'redis'
    group 'redis'
    mode 0755
    recursive true
  end

  template "/etc/redis_util.conf" do
    owner 'root'
    group 'root'
    mode 0644
    source "redis.conf.erb"
    variables({
      :pidfile => '/var/run/redis_util.pid',
      :basedir => '/data/redis',
      :logfile => '/data/redis/redis.log',
      :port  => '6379',
      :loglevel => 'notice',
      :timeout => 3000,
    })
  end

  template "/data/monit.d/redis_util.monitrc" do
    owner 'root'
    group 'root'
    mode 0644
    source "redis.monitrc.erb"
    variables({
      :profile => '1',
      :configfile => '/etc/redis_util.conf',
      :pidfile => '/var/run/redis_util.pid',
      :logfile => '/data/redis',
      :port => '6379',
    })
  end

  execute "monit reload" do
    action :run
  end

end
