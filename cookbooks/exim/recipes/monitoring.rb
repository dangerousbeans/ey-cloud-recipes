# Monitoring Automation for exim + collectd... use at your own risk.

execute "touch /opt/collectd/etc/keep.collectd.conf" do
  action :run
end
@@db_name = []
node[:applications].each do |app_name,data|
  @@db_name << app_name
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

execute "add_queue_count_to_types.db" do
  command 'echo "queue_count		value:GAUGE:U:U" >> /opt/collectd/lib/collectd/types.db'
  #not_if { "grep queue_count /opt/collectd/lib/collectd/types.db" }
end

execute "pkill -TERM -f 'collectd'" do
  action :run
end

