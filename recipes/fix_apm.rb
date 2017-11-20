#######################################
# The following was taken from the PreRequisite Scanner
# begin PRS Section
# Install RPM's
package node['apm']['rhel']

# set ulimits needed for ibm_apm
## max number of processes
set_limit '*' do
  type 'hard'
  item 'nproc'
  value unlimited
  use_system true
end

## max number of open file descriptors
set_limit '*' do
  type 'hard'
  item 'nofile'
  value 33000
  use_system true
end

set_limit '*' do
  type 'soft'
  item 'nofile'
  value 33000
  use_system true
end

## limits the core file size (KB)
set_limit '*' do
  type 'hard'
  item 'core'
  value 390001
  use_system true
end

set_limit '*' do
  type 'soft'
  item 'core'
  value 390001
  use_system true
end
# end PRS Section
#######################################

# Create the dir's that are needed by apm
directory node['apm']['install_dir'] do
  owner 'root'
  group 'root'
  mode '0755'
  recursive true
  action :create
end

# Download the APM binary
remote_file "#{node['apm']['media_dir']}/#{node['apm']['package']}" do
  source "#{node['media_url']}/#{node['apm']['package']}"
  not_if { File.exist?("#{node['apm']['package_dir']}/ccm/apm") }
  not_if { File.exist?("#{node['apm']['install_dir']}/install.sh") }
  owner 'root'
  group 'root'
  mode '0644'
end

# untar the apm binary file
tar_extract "#{node['apm']['media_dir']}/#{node['apm']['package']}" do
  action :extract_local
  target_dir node['apm']['install_dir']
  creates "#{node['apm']['install_dir']}/install.sh"
  compress_char ''
  not_if { File.exist?("#{node['apm']['package_dir']}/ccm/apm") }
  not_if { File.exist?("#{node['apm']['install_dir']}/install.sh") }
end

# Download the Agent's media for apm
node['media'].each do |media|
  remote_file "#{node['apm']['media_dir']}/#{media}" do
    source "#{node['media_url']}/#{media}"
    not_if { File.exist?("#{node['apm']['depot_dir']}/#{media}") }
    owner 'root'
    group 'root'
    mode '0644'
  end
end
