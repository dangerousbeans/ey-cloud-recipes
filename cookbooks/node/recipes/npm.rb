directory "/var/tmp/github" do
  action :create
  mode 0755
  owner node[:owner_name]
  group node[:owner_name]
end

execute "update_npm" do
  only_if { FileTest.directory?("/var/tmp/github/npm/.git") }
  command "cd /var/tmp/github/npm;git pull"
  user node[:owner_name]
end

execute "clone_npm" do
  not_if { FileTest.directory?("/var/tmp/github/npm/.git") }
  command "cd /var/tmp/github;git clone git://github.com/isaacs/npm.git"
  user node[:owner_name]
end

execute "make_install" do
  not_if { FileTest.exists?("/usr/bin/npm") }
  command "cd /var/tmp/github/npm;/usr/bin/node cli.js install"
end
