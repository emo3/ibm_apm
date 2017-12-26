# turn off Prerequisite Scanner
# comment this out until you resolve all issues
ENV['SKIP_PRECHECK'] = 'Yes'

selinux_state 'SELinux Permissive' do
  action :permissive
end

# install apm using answers file, write output to log
execute 'install_package' do
  command "#{node['apm']['install_dir']}/install.sh < \
#{node['apm']['temp_dir']}/#{node['apm']['myanswer_file']} > \
#{node['apm']['temp_dir']}/#{node['apm']['install_log']} 2>&1"
  cwd node['apm']['install_dir']
  not_if { File.exist?("#{node['apm']['package_dir']}/ccm/apm") }
  user 'root'
  group 'root'
  umask '022'
end

template '/home/db2apm/sqllib/profile.env' do
  source 'profile.env.erb'
  action :nothing
  owner 'db2apm'
  group 'db2iadm1'
  mode '0664'
end

selinux_state 'SELinux Enforcing' do
  action :enforcing
end

# create decoder dir
directory "#{node['apm']['package_dir']}/decoder" do
  owner 'root'
  group 'root'
  mode '0755'
  recursive true
  action :create
end

# Download the APM binary
remote_file "#{node['apm']['package_dir']}/decoder/#{node['apm']['decoder_file']}" do
  source "#{node['apm']['media_url']}/#{node['apm']['decoder_file']}"
  # not_if { File.exist?("#{node['apm']['package_dir']}/ccm/apm") }
  not_if { File.exist?("#{node['apm']['package_dir']}/decoder/#{node['apm']['decoder_file']}") }
  owner 'root'
  group 'root'
  mode '0644'
end

# untar the decoder file
tar_extract "#{node['apm']['package_dir']}/decoder/#{node['apm']['decoder_file']}" do
  action :extract_local
  target_dir "#{node['apm']['package_dir']}/decoder"
  creates "#{node['apm']['package_dir']}/decoder/set_my_env.sh"
  compress_char ''
  not_if { File.exist?("#{node['apm']['package_dir']}/decoder/set_my_env.sh") }
end

# delete the decoder file
file "#{node['apm']['package_dir']}/decoder/#{node['apm']['decoder_file']}" do
  action :delete
end

# print out the log file
# results = "#{node['apm']['temp_dir']}/#{node['apm']['install_log']}"
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
file "#{node['apm']['temp_dir']}/#{node['apm']['myanswer_file']}" do
  action :delete
end

# delete APM install dir
directory node['apm']['install_dir'] do
  recursive true
  action :delete
end
