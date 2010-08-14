# Node.js recipe
# Pulls in from github, so pardon the dust... if you need a more stable binary build it and store it on in your home directory

directory "/var/tmp/github" do
  action :create
  owner node[:owner_name]
  group node[:owner_name]
  mode 0755
end

execute "update_node_js" do
  command "cd /var/tmp/github/node;git pull"
  only_if { FileTest.directory?("/var/tmp/github/node/.git") }
  user node[:owner_name]
end

execute "clone_node_js" do
  command "cd /var/tmp/github;git clone git://github.com/ry/node.git"
  user node[:owner_name]
  not_if { FileTest.directory?("/var/tmp/github/node/.git") }
end

execute "configure_node_js" do
  command "cd /var/tmp/github/node;./configure --prefix=/usr"
  user node[:owner_name]
  only_if { FileTest.directory?("/var/tmp/github/node/configure") }
end

execute "make_node_js" do
  command "cd /var/tmp/github/node;make -j1"
  user node[:owner_name]
end

execute "make_install_node_js" do
  command "cd /var/tmp/github/node;make install"
  not_if { FileTest.exists?("/usr/bin/node") }
end


