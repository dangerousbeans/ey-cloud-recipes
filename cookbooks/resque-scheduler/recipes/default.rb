# This could be a recipe, but it's not. ;)
#
#
# Cookbook Name:: resque
# Recipe:: default
#
if ['solo', 'util'].include?(node[:instance_role])

  %w[resque redis redis-namespace yajl-ruby resque-scheduler].each do |install_gem|
    gem_package install_gem do
      action :install
    end
  end

   node[:applications].each do |app, data|
    template "/etc/monit.d/resque_scheduler_#{app}.monitrc" do
      owner 'root'
      group 'root'
      mode 0644
      source "resque-scheduler.monitrc.erb"
      variables({
      :app_name => app,
      :rails_env => node[:environment][:framework_env]
      })
    end

    remote_file "/data/#{app}/shared/bin/resque-scheduler" do
     source "resque-scheduler"
     owner 'root'
     group 'root'
     mode 0755
     backup 0
    end
   end

   execute "ensure-resque-is-setup-with-monit" do 
    command %Q{ 
    monit reload 
    } 
  end
end
