node[:deploy].each do |application, deploy|

  command <<-eos
    sed -i -E 's/(graphiteUrl:\s*).+,/\1 "#{deploy['grafana']['graphite_url']}",/g' #{deploy[:deploy_to]}/src/config.js
  eos

  elasticsearch_ip = node[:opsworks][:layers]['elasticsearch'][:instances].first.[:private_ip]
  command <<-eos
    sed -i -E 's/(elasticsearch:\s*).+,/\1 "http://#{elasticsearch_ip}:9200",/g' #{deploy[:deploy_to]}/src/config.js
  eos

end
