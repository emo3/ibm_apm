# set the IP and chef server name
hostsfile_entry node['chefsrv_ip'] do
  hostname node['chefsrv_name']
  action   :create
  unique   true
end
