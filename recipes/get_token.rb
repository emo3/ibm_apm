require 'net/http'
require 'uri'
require 'openssl'
require 'json'
require 'nokogiri'

xml_resp = Nokogiri::XML(File.open("#{node['apm']['package_dir']}/wlp/usr/shared/config/clientSecrets.xml"))
value = ''
xml_resp.xpath('//variable').each do |xml_var|
  next unless xml_var['name'] == 'client.secret.apmui'
  value = xml_var['value']
  break
end

classpath = "#{node['apm']['decoder_dir']}/bootstrap.jar:#{node['apm']['decoder_dir']}/com.ibm.ws.emf.jar:#{node['apm']['decoder_dir']}/com.ibm.ws.runtime.jar:#{node['apm']['decoder_dir']}/ffdcSupport.jar:#{node['apm']['decoder_dir']}/org.eclipse.emf.common.jar:#{node['apm']['decoder_dir']}/org.eclipse.emf.ecore.jar"
# puts ("value=#{value}")
output = Mixlib::ShellOut.new("#{node['apm']['package_dir']}/kafka/bin/java -cp #{classpath} com.ibm.ws.security.util.PasswordDecoder #{value}|awk '{print $8}'|sed 's/\"//g'")
output.run_command
output.error!
decodedpw = output.stdout
# decodedpw = output.stdout(/decoded password == "(.*)"/)
puts "decodedpw=#{decodedpw}"

uri = URI.parse('https://myapm:8099/oidc/endpoint/OP/token')
request = Net::HTTP::Post.new(uri)
request.set_form_data(
  'grant_type' => 'password',
  'client_id' => 'rpapmui',
  # 'client_secret' => decodedpw,
  'client_secret' => 'ZnV7T2o/ZV5HSTMraSVYMlIwdXwgKy',
  'username' => 'apmadmin',
  'password' => 'apmpass',
  'scope' => 'openid'
)
req_options = {
  use_ssl: uri.scheme == 'https',
  verify_mode: OpenSSL::SSL::VERIFY_NONE,
}
response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
  http.request(request)
end
if response.is_a?(Net::HTTPSuccess)
  token1 = JSON.parse(response.body)
  node.default['apm']['access_token'] = token1['access_token']
else
  node.default['apm']['access_token'] = 'ERROR'
end
# puts "access_token=#{node['apm']['access_token']}"
