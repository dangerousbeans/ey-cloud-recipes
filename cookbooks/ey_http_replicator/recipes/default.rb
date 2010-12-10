execute "verify_binhost" do
  command "grep -q -v "PORTAGE_BINHOST.*http://ec2-174-129-241-164\.compute-1\.amazonaws.com"/etc/make.conf"
end

update_file "add http_proxy to /etc/make.conf" do
    path "/etc/make.conf"
    body "http_proxy=\"http://cloud.replicator.eydistro.engineyard.com:5254\""
    not_if { "grep http_proxy /etc/make.conf"}
end

