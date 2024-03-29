require 'net/http'
require 'uri'
require 'openssl'
require 'json'
require 'nokogiri'
require_relative 'token'

# gu_header = %w(_id _href _modifiedAt _modifiedBy label description _isDefault configuration function)
uri = URI.parse('https://myapm:8091/1.0/thresholdmgmt/threshold_types/itm_private_situation/thresholds')
# puts("GT:access_token=#{$access_token}")
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
  # data = Nokogiri::HTML(response.body)
  data = JSON(response.body)
  puts data
  items = data['_items']
  puts items
  items.each do |line|
    line.each do |a, b|
      puts '' if a.eql? '_id'
      puts "#{a} == #{b}"
    end
  end
else
  puts('BAD!')
end
