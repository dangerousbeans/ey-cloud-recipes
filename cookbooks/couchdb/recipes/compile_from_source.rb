#
# Cookbook Name:: couchdb
# Recipe:: compile_from_source
#

version  = "1.0.1"
tarfile  = "apache-couchdb-#{version}.tar.gz"
work_dir = "/tmp"
src_file = "#{work_dir}/#{tarfile}"
src_dir  = src_file.slice(/(.+)\.tar\.gz$/, 1)

execute "stop CouchDB" do
  command "/etc/init.d/couchdb stop &> /dev/null || true"
  only_if "! couchdb -V | grep #{version}"
end

remote_file src_file do
  source tarfile
  backup false
  only_if "! couchdb -V | grep #{version}"
end

execute "decompress #{tarfile}" do
  cwd work_dir
  command "tar -xzf #{tarfile}"
  only_if "ls #{src_file}"
end

execute "configure CouchDB" do
  cwd src_dir
  command %Q(
    ./configure \
    --prefix=/usr \
    --localstatedir=/var \
    --sysconfdir=/etc
  )
  only_if "ls #{src_dir}"
end

execute "compile and install CouchDB" do
  cwd src_dir
  command "make && make install"
  only_if "ls #{src_dir}/Makefile"
end

directory src_dir do
  action :delete
  recursive true
  only_if "ls #{src_dir}"
end

file src_file do
  action :delete
  backup false
  only_if "ls #{src_file}"
end

user "couchdb" do
  home "/var/lib/couchdb"
  shell "/sbin/nologin"
end

%w(/etc /var/lib /var/log /var/run).each do |dir|
  directory "#{dir}/couchdb" do
    owner "couchdb"
    group "couchdb"
    mode 0750
  end

  execute "change owner:group of #{dir}/couchdb" do
    command "chown -R couchdb:couchdb #{dir}/couchdb"
  end
end

remote_file "/etc/init.d/couchdb" do
  source "couchdb.init"
  owner "root"
  group "root"
  mode 0755
end

remote_file "/etc/conf.d/couchdb" do
  source "couchdb.conf"
  owner "root"
  group "root"
  mode 0644
end
