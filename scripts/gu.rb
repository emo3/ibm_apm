require 'net/http'
require 'uri'
require 'openssl'
require 'json'
require_relative 'token'

# uri = URI.parse('https://myapm:9443/1.0/authzn/users')
uri = URI.parse('https://myapm:8091/1.0/thresholdmgmt/threshold_types/itm_private_situation/thresholds')
request = Net::HTTP::Get.new(uri)
request.content_type = 'application/json'
request['Authorization'] = "Bearer #{$access_token}"
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
  data = JSON.parse(response.body)
  items = data['_items']
  items.each do |line|
    line.each do |a, b|
      puts '' if a.eql? '_id'
      puts "#{a} == #{b}"
    end
  end
else
  puts('BAD!')
end
