update_file "add http_proxy to /etc/make.conf" do
    path "/etc/make.conf"
    body "http_proxy=\"http://cloud.replicator.eydistro.engineyard.com:5254\""
    not_if "grep #{body} /etc/make.conf"
end

