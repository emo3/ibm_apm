ruby_block 'getusers' do
  require 'net/http'
  require 'uri'
  require 'openssl'
  require 'json'
  require_relative 'token1'

  uri = URI.parse('https://myurl:9443/1.0/authzn/users')
  request = Net::HTTP::Get.new(uri)
  request.content_type = 'application/json'
  request['Authorization'] = "Bearer #{node['apm']['access_token']}"
  request['Accept'] = 'application/json'
  request['X-Ibm-Service-Location'] = 'na'

  req_options = {
    use_ssl: uri.scheme == 'https',
    verify_mode: OpenSSL::SSL::VERIFY_NONE,
  }

  response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
    http.request(request)
  end

  if response.is_a?(Net::HTTPSuccess)
    parsed_resp = JSON.parse(response.body)
    # output result
    puts "resp = #{parsed_resp}"
  else
    puts 'ERROR getuser'
  end
end
