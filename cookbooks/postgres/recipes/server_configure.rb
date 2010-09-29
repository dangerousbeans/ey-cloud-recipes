postgres_version = node[:postgres_version]
postgres_root = node[:postgres_root]

execute "set_kernel.shmmax" do
  command "sysctl -w kernel.shmmax=#{@node[:total_memory]}"
end

directory "#{postgres_root}/#{postgres_version}" do
  owner "postgres"
  group "postgres"
  mode "0755"
  action :create
  recursive true
end

directory "/var/run/postgresql" do
  owner "postgres"
  group "postgres"
  mode "0755"
  action :create
  recursive true
end

remote_file "/etc/conf.d/postgresql-#{postgres_version}" do
  source "#{postgres_version}/postgresql.conf"
  owner "root"
  group "root"
  mode "0644"
  backup 0
end

 execute "init-postgres" do
  command "initdb -D #{postgres_root}/#{postgres_version}/data --encoding=UTF8 --locale=en_US.UTF-8"
  action :run
  user "postgres"
  only_if "[ ! -d #{postgres_root}/#{postgres_version}/data ]"
end

template "#{postgres_root}/#{postgres_version}/data/postgresql.conf" do
  source "#{postgres_version}/postgresql.conf.erb"
  owner "postgres"
  group "postgres"
  backup 0
  mode 0600

  variables(
    :sysctl_shared_buffers => node[:sysctl_shared_buffers],
    :shared_buffers => node[:shared_buffers],
    :max_fsm_pages => node[:max_fsm_pages],
    :max_fsm_relations => node[:max_fsm_relations],
    :maintenance_work_mem => node[:maintenance_work_mem],
    :work_mem => node[:work_mem],
    :max_stack_depth => node[:max_stack_depth],
    :effective_cache_size => node[:effective_cache_size],
    :default_statistics_target => node[:default_statistics_target],
    :logging_collector => node[:logging_collector],
    :log_rotation_age => node[:log_rotation_age],
    :log_rotation_size => node[:log_rotation_size],
    :checkpoint_timeout => node[:checkpoint_timeout],
    :checkpoint_segments => node[:checkpoint_segments],
    :wal_buffers => node[:wal_buffers],
    :wal_writer_delay => node[:wal_writer_delay],
    :postgres_root => node[:postgres_root],
    :postgres_version => node[:postgres_version]
  )
end

file "#{postgres_root}/#{postgres_version}/custom.conf" do
  action :create
  owner node[:owner_name]
  group node[:owner_name]
  mode 0644
    not_if { FileTest.exists?("#{postgres_root}/#{postgres_version}/custom.conf") }
  end

template "#{postgres_root}/#{postgres_version}/data/pg_hba.conf" do
  owner 'postgres'
  group 'postgres'
  backup 0
  mode 0600
  source "pg_hba.conf.erb"
  variables({
    :dbuser => node[:users].first[:username],
    :dbpass => node[:users].first[:password]
  })
end

execute "postgresql-restart" do
  command "/etc/init.d/postgresql-#{postgres_version} restart"
  action :nothing

  subscribes :run, resources(
    :template => "#{postgres_root}/#{postgres_version}/data/postgresql.conf",
    :file     => "#{postgres_root}/#{postgres_version}/custom.conf",
    :template => "#{postgres_root}/#{postgres_version}/data/pg_hba.conf")

  only_if "/etc/init.d/postgresql-#{postgres_version} status"
end

user "postgres" do
  action :unlock
end

execute "start-postgres" do
  command "/etc/init.d/postgresql-#{postgres_version} restart"
    action :run
  not_if "/etc/init.d/postgresql-#{postgres_version} status | grep -q start"
end

username = node.engineyard.ssh_username
password = node.engineyard.ssh_password

psql "create-db-user-#{username}" do
  sql "create user #{username} with encrypted password '#{password}' createdb"
  sql_not_if :sql => 'SELECT * FROM pg_roles',
             :assert => "grep -q #{username}"
end

psql "alter-db-user-postgres" do
  sql "ALTER user postgres ENCRYPTED PASSWORD '#{password}'"
end

node.engineyard.apps.each do |app|
  createdb app.database_name do
    owner username
  end
end
