include_recipe '::get_token'

uri = URI.parse('https://myapm:8091/1.0/thresholdmgmt/threshold_types/itm_private_situation/thresholds')
request = Net::HTTP::Post.new(uri)
request.content_type = 'application/json'
request['Authorization'] = "Bearer #{node['apm']['access_token']}"
request['Accept'] = 'application/json'
request['X-Ibm-Service-Location'] = 'na'
request.body = JSON.dump(
  'configuration' => {
    'payload' => {
      'formulaElements' => [{
        'metricName' => 'KLZ_CPU.Timestamp',
        'function' => '*MKTIME',
        'timeDelta' => {
          'unit' => 'Hours',
          'delta' => '3',
          'operator' => '+',
        },
        'threshold' => '1455767100000',
        'operator' => '*EQ',
      }],
      'severity' => 'Fatal',
      'period' => '011500',
      'matchBy' => 'KLZCPU.CPUID',
      'periods' => 3,
      'actions' => [{
        'name' => 'command',
        'commandWhen' => 'Y',
        'command' => 'ps -ef',
        'commandFrequency' => 'Y',
        'commandWhere' => 'N',
      }],
      'operator' => '*OR',
    },
    'type' => 'json',
  },
  'description' => 'My description',
  'label' => 'My_Threshold2'
)
puts "request.body=#{request.body}"
req_options = {
  use_ssl: uri.scheme == 'https',
  verify_mode: OpenSSL::SSL::VERIFY_NONE,
}
response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
  http.request(request)
end
if response.is_a?(Net::HTTPSuccess)
  puts "response.body=#{response.body}"
  puts "response.code=#{response.code}"
else
  puts "BAD response.code=#{response.code}"
end
