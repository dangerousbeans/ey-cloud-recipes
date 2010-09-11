postgres_version = node[:postgres_version]
postgres_root = node[:postgres_root]

case postgres_version

when "9.0"

  execute "emerge -C =dev-db/postgresql-server-8.3.5" do
    action :run
    only_if { FileTest.directory?("/var/db/pkg/dev-db/postgresql-server-8.3.5") }
  end

  execute "emerge -C =dev-db/postgresql-base-8.3.5" do
    action :run
    only_if { FileTest.directory?("/var/db/pkg/dev-db/postgresql-base-8.3.5") }
  end

  directory "/engineyard/portage/packages" do
    action :create
    mode 0755
    owner "root"
    group "root"
  end

  directory "/engineyard/portage/packages/dev-db" do
    action :create
    mode 0755
    owner "root"
    group "root"
  end

  packages_to_install = ['dev-db/postgresql-base-9.0_rc1.tbz2','dev-db/postgresql-server-9.0_rc1.tbz2'].each do |packages_to_fetch|
    remote_file "/engineyard/portage/packages/#{packages_to_fetch}" do
      source "http://ey-portage.s3.amazonaws.com/#{node[:kernel][:machine]}/#{packages_to_fetch}"
      not_if { FileTest.exists?("/engineyard/portage/packages/#{packages_to_fetch}") }
      backup false
    end
  end

  execute "emerge /engineyard/portage/packages/dev-db/postgresql-base-9.0_rc1.tbz2" do
    action :run
    not_if { FileTest.directory?("/var/db/pkg/dev-db/postgresql-base-9.0_rc1") }
  end

  execute "emerge /engineyard/portage/packages/dev-db/postgresql-server-9.0_rc1.tbz2" do
    action :run
    not_if { FileTest.directory?("/var/db/pkg/dev-db/postgresql-server-9.0_rc1") }
  end

  execute "eselect postgresql set #{postgres_version}" do
  action :run
  end

when "8.4"

    execute "emerge -C =dev-db/postgresql-server-8.3.5" do
    action :run
    only_if { FileTest.directory?("/var/db/pkg/dev-db/postgresql-server-8.3.5") }
  end

  execute "emerge -C =dev-db/postgresql-base-8.3.5" do
    action :run
    only_if { FileTest.directory?("/var/db/pkg/dev-db/postgresql-base-8.3.5") }
  end

  directory "/engineyard/portage/packages" do
    action :create
    mode 0755
    owner "root"
    group "root"
  end

  directory "/engineyard/portage/packages/dev-db" do
    action :create
    mode 0755
    owner "root"
    group "root"
  end

  packages_to_install = ['dev-db/postgresql-base-8.4.2.tbz2','dev-db/postgresql-server-8.4.2.tbz2'].each do |packages_to_fetch|
    remote_file "/engineyard/portage/packages/#{packages_to_fetch}" do
      source "http://ey-portage.s3.amazonaws.com/#{node[:kernel][:machine]}/#{packages_to_fetch}"
      not_if { FileTest.exists?("/engineyard/portage/packages/#{packages_to_fetch}") }
      backup false
    end
  end

  execute "emerge /engineyard/portage/packages/dev-db/postgresql-base-8.4.2.tbz2" do
    action :run
    not_if { FileTest.directory?("/var/db/pkg/dev-db/postgresql-base-8.4.2") }
  end

  execute "emerge /engineyard/portage/packages/dev-db/postgresql-server-8.4.2.tbz2" do
    action :run
    not_if { FileTest.directory?("/var/db/pkg/dev-db/postgresql-server-8.4.2") }
  end

  execute "eselect postgresql set #{postgres_version}" do
    action :run
  end
end
