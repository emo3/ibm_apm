default['apm']['version']      = '8.1.4.0'
default['apm']['package']      = "apm_base_#{node['apm']['version']}.tar"
default['apm']['agents_lnx']   = "apm_base_agents_xlinux_#{node['apm']['version']}.tar"
default['apm']['agents_pnx']   = "apm_base_agents_plinuxle_#{node['apm']['version']}.tar"
default['apm']['agents_aix']   = "apm_base_agents_aix_#{node['apm']['version']}.tar"
default['apm']['answer_file']  = 'apm_base_install.txt'
default['apm']['decoder_file'] = 'decoder.tar'
default['apm']['myanswer_file'] = 'apm_base_install-my.txt'
default['apm']['cots_dir']     = '/sfcots'
default['apm']['lvg_name']     = 'apmvg'
default['apm']['app_dir']      = "#{node['apm']['cots_dir']}/apps"
default['apm']['media_dir']    = "#{node['apm']['app_dir']}/media"
default['apm']['install_dir']  = "#{node['apm']['media_dir']}/apm"
default['apm']['package_dir']  = "#{node['apm']['app_dir']}/apm"
default['apm']['depot_dir']    = "#{node['apm']['package_dir']}/ccm/depot"
default['apm']['decoder_dir']  = "#{node['apm']['package_dir']}/decoder"
default['apm']['rhel']         = %w(bc lsof rsync zip unzip libstdc++.i686 pam.i686 sg3_utils ksh)
default['apm']['install_log']  = 'apm_base_install.log'
default['apm']['access_token'] = ' '
default['apm']['media'] = [
  node['apm']['agents_lnx'],
  node['apm']['agents_pnx'],
  node['apm']['agents_aix'],
]
default['apm']['apm_ip']       = '10.1.1.20'
default['apm']['apm_name']     = 'myapm'
default['apm']['media_url']    = 'http://10.1.1.30/media'
default['apm']['depot_url']    = 'http://10.1.1.30/media/depot'
default['apm']['temp_dir']     = '/tmp'
default['apm']['chefsrv_ip']   = '10.1.1.10'
default['apm']['chefsrv_name'] = 'chefsrv'
default['apm']['chef_client']  = 'chef-13.6.0-1.el7.x86_64.rpm'
