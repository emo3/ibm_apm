# set the IP and chef server name
hostsfile_entry node['apm']['chefsrv_ip'] do
  hostname node['apm']['chefsrv_name']
  action   :create
  unique   true
end
