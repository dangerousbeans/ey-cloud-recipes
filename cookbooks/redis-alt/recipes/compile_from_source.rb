#
# Cookbook Name:: redis
# Recipe:: compile_from_source
#

version  = "1.3.17"
tarfile  = "redis-2.0.0-rc4.tar.gz"
work_dir = "/tmp"
src_file = "#{work_dir}/#{tarfile}"
src_dir  = src_file.slice(/(.+)\.tar\.gz$/, 1)

execute "stop Redis" do
  command "/etc/init.d/redis stop || true"
  only_if "! redis-cli info | grep #{version}"
end

remote_file src_file do
  source tarfile
  backup false
  only_if "! redis-cli info | grep #{version}"
end

execute "decompress #{tarfile}" do
  cwd work_dir
  command "tar -xzf #{tarfile}"
  only_if "ls #{src_file}"
end

execute "compile source" do
  cwd src_dir
  command "make"
  only_if "ls #{src_dir}"
end

execute "install binaries" do
  cwd src_dir
  command "mv redis-benchmark redis-check-aof redis-check-dump redis-cli redis-server /usr/bin"
  only_if "ls #{src_dir}/redis-server"
end

directory src_dir do
  action :delete
  recursive true
end

file src_file do
  action :delete
  backup false
end

user "redis" do
  home "/var/lib/redis"
  shell "/sbin/nologin"
end

%w(/var/lib /var/log /var/run).each do |dir|
  directory "#{dir}/redis" do
    owner "redis"
    group "redis"
    mode 0750
  end

  execute "change owner:group of #{dir}/redis" do
    command "chown -R redis:redis #{dir}/redis"
  end
end

remote_file "/etc/init.d/redis" do
  source "redis.init"
  owner "root"
  group "root"
  mode 0755
end

remote_file "/etc/conf.d/redis" do
  source "redis.conf"
  owner "root"
  group "root"
  mode 0644
end
