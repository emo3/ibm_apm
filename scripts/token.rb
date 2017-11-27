require 'net/http'
require 'uri'
require 'openssl'
require 'json'
require 'nokogiri'

xml_resp = Nokogiri::XML(File.open('/sfcots/apps/apm/wlp/usr/shared/config/clientSecrets.xml'))
value = ''
xml_resp.xpath('//variable').each do |node|
  next unless node['name'] == 'client.secret.apmui'
  value = node['value']
  break
end

# classpath = '/sfcots/apps/apm/decoder/bootstrap.jar:/sfcots/apps/apm/decoder/com.ibm.ws.emf.jar:/sfcots/apps/apm/decoder/com.ibm.ws.runtime.jar:/sfcots/apps/apm/decoder/ffdcSupport.jar:/sfcots/apps/apm/decoder/org.eclipse.emf.common.jar:/sfcots/apps/apm/decoder/org.eclipse.emf.ecore.jar'
# puts ("value=#{value}")
#  output = `/sfcots/apps/apm/kafka/bin/java -cp #{classpath} com.ibm.ws.security.util.PasswordDecoder #{value}`
#  decodedpw = output.match(/decoded password == "(.*)"/)[1]
decodedpw = 'W2Q7M2M7dSc7JSRmSypcfiJRY0BtUU'

uri = URI.parse('https://myapm:8099/oidc/endpoint/OP/token')
request = Net::HTTP::Post.new(uri)
request.set_form_data(
  'grant_type' => 'password',
  'client_id' => 'rpapmui',
  'client_secret' => decodedpw,
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
  token = JSON.parse(response.body)
  $access_token = token['access_token']
else
  $access_token = 'ERROR'
end
