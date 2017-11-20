reboot 'Rebooting to use SELinux to disabled mode' do
  only_if "getenforce | egrep -qx 'Enforcing|Permissive'"
  action :reboot_now
  ignore_failure true
end
