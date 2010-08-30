#
# Cookbook Name:: couchdb
# Recipe:: compile_from_source
#

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

directory "/engineyard/portage/packages/dev-lang" do
  action :create
  owner "root"
  group "root"
  mode 0755
end

version  = "1.0.1"
tarfile  = "apache-couchdb-#{version}.tar.gz"
work_dir = "/tmp"
src_file = "#{work_dir}/#{tarfile}"
src_dir  = src_file.slice(/(.+)\.tar\.gz$/, 1)

execute "stop CouchDB" do
  command "/etc/init.d/couchdb stop &> /dev/null || true"
  only_if "! couchdb -V | grep #{version}"
end

packages_to_install = ['dev-lang/erlang-14.1.tbz2','dev-db/couchdb-1.0.1.tbz2'].each do |packages_to_fetch|

  remote_file "/engineyard/portage/packages/#{packages_to_fetch}" do
    source "http://ey-portage.s3.amazonaws.com/#{node[:kernel][:machine]}/#{packages_to_fetch}"
    backup false
    only_if "! couchdb -V | grep #{version}"
  end
end

execute "remove_old_erlang" do
  command "emerge -C erlang"
  action :run
  only_if { FileTest.directory?("/usr/lib/erlang/releases/R12B") }
end

execute "install_erlang" do
  command "ACCEPT_KEYWORDS='~amd64 ~x86' emerge /engineyard/portage/packages/dev-lang/erlang-14.1.tbz2"
  not_if { FileTest.directory?("/usr/lib/erlang/releases/R14A") }
end

execute "remove_old_couchdb_etc" do
  command "rm -rf /etc/couchdb;true"
  action :run
  only_if { FileTest.directory?("/usr/lib/couchdb/erlang/lib/couch-0.9.1") }
end

execute "remote_old_couchdb" do
  command "emerge -C couchdb"
  only_if { FileTest.directory?("/usr/lib/couchdb/erlang/lib/couch-0.9.1") }
end

execute "install_couchdb_1.0.1" do
  command "emerge /engineyard/portage/packages/dev-db/couchdb-1.0.1.tbz2"
  action :run
  not_if { FileTest.directory?("/usr/lib/couchdb/erlang/lib/couch-1.0.1") }
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
