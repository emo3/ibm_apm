ruby_block 'token1' do
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

  classpath = '/sfcots/apps/apm/decoder/bootstrap.jar:/sfcots/apps/apm/decoder/com.ibm.ws.emf.jar:/sfcots/apps/apm/decoder/com.ibm.ws.runtime.jar:/sfcots/apps/apm/decoder/ffdcSupport.jar:/sfcots/apps/apm/decoder/org.eclipse.emf.common.jar:/sfcots/apps/apm/decoder/org.eclipse.emf.ecore.jar'

  output = `/sfcots/apps/apm/kafka/bin/java -cp #{classpath} com.ibm.ws.security.util.PasswordDecoder #{value}`
  decodedpw = output.match(/decoded password == "(.*)"/)[1]

  uri = URI.parse('https://myurl:8099/oidc/endpoint/OP/token')
  request = Net::HTTP::Post.new(uri)
  request.set_form_data(
    'grant_type' => 'password',
    'client_id' => 'rpapmui',
    'client_secret' => decodedpw,
    'username' => 'apmadmin',
    'password' => 'XXXXXXXXXXXXXX',
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
    parsed_resp = JSON.parse(response.body)
    puts parsed_resp['access_token']
    node['apm']['access_token'] = parsed_resp['access_token']
  else
    node['apm']['access_token'] = 'ERROR'
  end
end
