execute "restart god" do
  command <<-SRC
    if pgrep god; then
      god quit
    fi
  SRC
  action :nothing
end

node.engineyard.apps.each do |app|

  case app.type
  when "rack"
    process_name = "unicorn"
  else
    process_name = "unicorn_rails"
  end

  template "/etc/god/unicorn_#{app.name}.rb" do
    owner 'root'
    group 'root'
    mode 0644
    source "unicorn_god.erb"
    variables(
      :application => app.name,
      :environment => node[:environment][:framework_env],
      :user => node.engineyard.environment.ssh_username,
      :group => node.engineyard.environment.ssh_username,
      :memory => "210",
      :process_name => process_name
    )
    notifies :run, resources(:execute => "restart god")
  end
end
