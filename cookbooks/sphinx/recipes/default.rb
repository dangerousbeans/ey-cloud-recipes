#
# Cookbook Name:: sphinx
# Recipe:: default
#

# Set your application name here
appname = "fds"

# Uncomment the flavor of sphinx you want to use
flavor = "thinking_sphinx"
#flavor = "ultrasphinx"

# If you want to have scheduled reindexes in cron, enter the minute
# interval here. This is passed directly to cron via /, so you should
# only use numbers between 1 - 59.
#
# If you don't want scheduled reindexes, just leave this commented.
#
# Uncommenting this line as-is will reindex once every 10 minutes.
 cron_interval = 10

if ['solo', 'app_master'].include?(node[:instance_role])
  
  gem_package "curb" do
    version "0.3.4"
    action :install
  end

  
run_for_app(appname) do |app_name, data|

  ey_cloud_report "Sphinx" do
      message "configuring #{flavor}"
    end

      directory "/var/run/sphinx" do
        owner node[:owner_name]
        group node[:owner_name]
        mode 0755
      end

      directory "/var/log/engineyard/sphinx/#{app_name}" do
        recursive true
        owner node[:owner_name]
        group node[:owner_name]
        mode 0755
      end

     directory "/data/#{app_name}/shared/config/#{flavor.split("_").join("")}" do
        owner node[:owner_name]
        group node[:owner_name]
        mode 0755
      end

     remote_file "/etc/logrotate.d/sphinx" do
        owner "root"
        group "root"
        mode 0755
        source "sphinx.logrotate"
        backup false
        action :create
      end

      package "app-misc/sphinx" do
        action :upgrade
        version "0.9.9"
      end

      remote_file "/engineyard/bin/thinking_sphinx_searchd" do
        source "thinking_sphinx_searchd"
        owner "root"
        group "root"
        backup 0
        mode 0755
      end

      begin
     template "/data/#{app_name}/shared/config/sphinx.yml" do
        owner node[:owner_name]
        group node[:owner_name]
        mode 0644
        source "sphinx.yml.erb"
        variables({
          :sphinx_ip => @node['master_app_server']['private_dns_name'].nil? ? "127.0.0.1" : @node['master_app_server']['private_dns_name'],
          :app_name => app_name,
          :flavor => flavor.eql?("thinking_sphinx") ? "thinkingsphinx" : flavor,
          :mem_limit => 32,
          :user => node[:owner_name]
        })
      end
      rescue
     template "/data/#{app_name}/shared/config/sphinx.yml" do
        owner node[:owner_name]
        group node[:owner_name]
        mode 0644
        source "sphinx.yml.erb"
        variables({
          :sphinx_ip => "localhost",
          :app_name => app_name,
          :flavor => flavor.eql?("thinking_sphinx") ? "thinkingsphinx" : flavor,
          :mem_limit => 32,
          :user => node[:owner_name]
        })
      end
    end

      template "/etc/monit.d/sphinx.#{app_name}.monitrc" do
        source "sphinx.monitrc.erb"
        owner node[:owner_name]
        group node[:owner_name]
        mode 0644
        variables({
          :app_name => app_name,
          :user => node[:owner_name],
          :flavor => flavor
        })
      end

      if cron_interval
        cron "sphinx index" do
          action  :create
          minute  "0-59/5"
          hour    '*'
          day     '*'
          month   '*'
          weekday '*'
          command "cd /data/#{app_name}/current && RAILS_ENV=#{node[:environment][:framework_env]} rake #{flavor}:index >/dev/null 2>&1"
          user node[:owner_name]
        end
      end
    end
  
  execute "monit-reload" do
    command "monit reload"
    action :run
  end
end

## this is for the other app / util instances.

if ['app', 'util'].include?(node[:instance_role])

  run_for_app(appname) do |app_name, data|
    template "/data/#{app_name}/shared/config/sphinx.yml" do
      owner node[:owner_name]
      group node[:owner_name]
      mode 0644
      backup 0
      source "sphinx.yml.erb"
      variables({
      :sphinx_ip => @node['master_app_server']['private_dns_name'].nil? ? "127.0.0.1" : @node['master_app_server']['private_dns_name'],
      :app_name => app_name,
      :flavor => flavor.eql?("thinking_sphinx") ? "thinkingsphinx" : flavor,
      :mem_limit => 32,
      :user => node[:owner_name]
      })
    end
  end
end
