define :createdb, :user => 'postgres' do
  db_name = params[:name]
  statement = %{su - postgres -c "psql -h localhost -c \\"SELECT * FROM pg_database\\""}
  owner = params[:owner]

  psql "create database for #{db_name}" do
    sql "CREATE DATABASE #{db_name} OWNER #{owner}"

    not_if "#{statement} | grep #{db_name}"
  end

  psql "grant permissions to #{owner} on #{db_name}" do
    action :nothing
    sql "grant all on database #{db_name} to #{owner}"

    subscribes :run, resources(:execute => "createdb-#{db_name}"), :immediately
  end

  psql "alter-public-schema-owner-on-#{db_name}-to-#{owner}" do
    action :nothing
    sql "ALTER SCHEMA public OWNER TO #{owner}"

    subscribes :run, resources(:psql => "grant permissions to #{owner} on #{db_name}"), :immediately
  end
end
