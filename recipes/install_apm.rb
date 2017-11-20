include_recipe '::setchefsrv'
include_recipe '::filesystem'
include_recipe '::fix_apm'

# turn off Prerequisite Scanner
# comment this out until you resolve all issues
ENV['SKIP_PRECHECK'] = 'Yes'

# Write answers contents to a file
# template "#{node['temp_dir']}/#{node['apm']['answer_file']}" do
template "#{node['temp_dir']}/#{node['apm']['myanswer_file']}" do
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

include_recipe 'ibm_apm::logout'

selinux_state 'SELinux Permissive' do
  action :permissive
end

# install apm using answers file, write output to log
execute 'install_package' do
  command "#{node['apm']['install_dir']}/install.sh < \
#{node['temp_dir']}/#{node['apm']['myanswer_file']} > \
#{node['temp_dir']}/#{node['apm']['install_log']} 2>&1"
  cwd node['apm']['install_dir']
  not_if { File.exist?("#{node['apm']['package_dir']}/ccm/apm") }
  user 'root'
  group 'root'
  umask '022'
end

selinux_state 'SELinux Enforcing' do
  action :enforcing
end

# print out the log file
# results = "#{node['temp_dir']}/#{node['apm']['install_log']}"
# ruby_block 'list_results' do
#  only_if { ::File.exist?(results) }
#  block do
#    print "\n"
#    File.open(results).each do |line|
#      print line
#    end
#  end
# end

# delete the apm tar file
file "#{node['apm']['media_dir']}/#{node['apm']['package']}" do
  action :delete
end

# delete all the Agent's compressed files in the media dir
directory node['apm']['media_dir'] do
  action    :delete
  recursive true
end

# delete all misc temporary files created during this process
file "#{node['temp_dir']}/#{node['apm']['myanswer_file']}" do
  action :delete
end

# delete APM install dir
directory node['apm']['install_dir'] do
  recursive true
  action :delete
end