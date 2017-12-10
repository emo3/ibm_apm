include_recipe '::get_token'

# gu_header = %w(_id _href _modifiedAt _modifiedBy label description _isDefault configuration function)
uri = URI.parse('https://myapm:8091/1.0/thresholdmgmt/threshold_types/itm_private_situation/thresholds')
# puts("GT:access_token=#{node['apm']['access_token']}")
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
  data = JSON.parse(response.body)
  items = data['_items']
  items.each do |line|
    line.each do |a, b|
      puts '' if a.eql? '_id'
      puts "#{a} == #{b}"
    end
  end
else
  puts "BAD=#{response.code}!"
end
