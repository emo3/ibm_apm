include_recipe '::setchefsrv'
include_recipe '::filesystem'
include_recipe '::fix_apm'

# Write answers contents to a file
# template "#{node['temp_dir']}/#{node['apm']['answer_file']}" do
template "#{node['apm']['temp_dir']}/#{node['apm']['myanswer_file']}" do
  ############
  ## prompt answers
  # continue=1 yes
  # 1=change dir=Yes
  # {full path install dir} # install dir
  # 1=accept license
  # change default password=2 no
  # configure agent=1 yes
  # {full path agent dir} # agent path
  # accept default dir
  # accept IP
  # use values
  # install DB2
  #############
  # source "#{node['apm']['answer_file']}.erb"
  source "#{node['apm']['myanswer_file']}.erb"
  action :create
  owner 'root'
  group 'root'
  mode '0644'
end
