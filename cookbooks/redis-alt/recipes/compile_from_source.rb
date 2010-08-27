#
# Cookbook Name:: redis
# Recipe:: compile_from_source
#

tarfile  = "redis-2.0.0-rc4.tar.gz"
work_dir = "/tmp"
src_file = "#{work_dir}/#{tarfile}"
src_dir  = src_file.slice(/(.+)\.tar\.gz/, 1)

remote_file src_file do
  source tarfile
  backup false
end

ruby_block "check Redis src version" do
  block do
    version = `tar -xzf #{src_file} -O`.grep(/#define REDIS_VERSION/).first.slice(/"([^"]+)"/, 1)
    @src_is_newer = `redis-cli info`.grep(/#{version}/).empty?
  end
end

service "redis" do
  supports :restart => true, :status => true
  action :stop
  only_if @src_is_newer
end

execute "decompress #{tarfile}" do
  cwd work_dir
  command "tar -xzf #{tarfile}"
  only_if File.exist?(src_file) && @src_is_newer
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
