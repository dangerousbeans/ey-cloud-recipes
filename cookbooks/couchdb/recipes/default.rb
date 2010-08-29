#
# Cookbook Name:: couchdb
# Recipe:: default
#

package "dev-db/couchdb" do
  version "0.9.1"
  action :purge
end

require_recipe "couchdb::compile_from_source"

storage_dir = case node[:instance_role]
  when "db_master", "db_slave", "solo" then "/db"
  else "/data"
end

directory "#{storage_dir}/couchdb" do
  owner "couchdb"
  group "couchdb"
  mode 0750
end

template "/etc/couchdb/local.ini" do
  source "local.ini.erb"
  mode 0640
  variables(
    :bind => "0.0.0.0",
    :port => 5984,
    :database_dir   => "#{storage_dir}/couchdb",
    :view_index_dir => "#{storage_dir}/couchdb"
  )
  backup false
end

execute "start CouchDB" do
  command "echo '/etc/init.d/couchdb start | at now'"
  not_if "/etc/init.d/couchdb status"
end
