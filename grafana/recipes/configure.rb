node[:deploy].each do |application, deploy|

  update_config_graphite_url = <<-eos
    sed -i -E 's/(graphiteUrl:\s*).+,/\1 "#{node[:grafana][:graphite_url]}",/g' #{deploy[:deploy_to]}/src/config.js
  eos

  elasticsearch_ip = node[:opsworks][:layers]['elasticsearch'][:instances].values.first[:private_ip]
  update_config_elasticsearch = <<-eos
    sed -i -E 's/(elasticsearch:\s*).+,/\1 "http://#{elasticsearch_ip}:9200",/g' #{deploy[:deploy_to]}/src/config.js
  eos

  execute update_config_graphite_url
  execute update_config_elasticsearch

end
