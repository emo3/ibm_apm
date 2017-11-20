execute 'Logging out to get things to work' do
  not_if { File.exist?("#{node['apm']['app_dir']}/DONOTDELETE") }
  command <<-EOM
  touch "#{node['apm']['app_dir']}/DONOTDELETE"
#  ulimit -c 390001
#  ulimit -n 33000
#  ulimit -u 8192
  logout
  EOM
end
