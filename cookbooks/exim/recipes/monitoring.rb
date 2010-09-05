# Monitoring Automation for exim + collectd... use at your own risk.

execute "touch /opt/collectd/etc/keep.collectd.conf" do
  action :run
end
@@db_name = []
node[:applications].each do |app_name,data|
  @@db_name << app_name
end

directory "/etc/exim" do
  action :create
  owner "root"
  group "root"
  mode 0755
end

remote_file "/etc/exim/collectd_mailq.sh" do
  source "collectd_mailq.sh"
  owner "root"
  group "root"
  mode 0755
  backup 0
end

  template "/opt/collectd/etc/collectd.conf" do
  owner 'root'
  group 'root'
  mode 0644
  backup 0
  source "collectd.conf.erb"
  variables({
    :databases => @@db_name,
    :user => node[:owner_name],
    :alert_script => "/engineyard/bin/ey-alert.rb",
    :load_warning => "8",
    :load_failure => "20"
  })
end

update_file "add queue_count to types.db" do
  path "/opt/collectd/lib/collectd/types.db"
  body "queue_count		value:GAUGE:U:U"
  not_if "grep 'queue_count' /opt/collectd/lib/collectd/types.db"
end

execute "telinit q" do
  action :run
end

