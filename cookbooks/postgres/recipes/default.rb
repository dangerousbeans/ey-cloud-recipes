if ['solo', 'db_master'].include?(node[:instance_role])
  require_recipe "postgres::server_install"
  require_recipe "postgres::gem"
  require_recipe "postgres::server_configure"
  require_recipe "postgres::eybackup"
  require_recipe "postgres::client_config"
end
if ['solo', 'app_master', 'app', 'util'].include?(node[:instance_role])
  require_recipe "postgres::server_install"
  require_recipe "postgres::database"
  require_recipe "postgres::client_config"
end
