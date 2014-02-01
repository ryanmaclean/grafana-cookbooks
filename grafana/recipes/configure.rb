node[:deploy].each do |application, deploy|

  config_path = "#{deploy[:deploy_to]}/config.js"

  update_config_graphite_url = <<-eos
    sed -i -E 's^(graphiteUrl:\s*).+,^\1 "#{node[:grafana][:graphite_url]}",^g' #{config_path}
  eos

  elasticsearch_ip = node[:opsworks][:layers]['elasticsearch'][:instances].values.first[:private_ip]
  update_config_elasticsearch = <<-eos
    sed -i -E 's^(elasticsearch:\s*).+,^\1 "http://#{elasticsearch_ip}:9200",^g' #{config_path}
  eos

  execute update_config_graphite_url
  execute update_config_elasticsearch

end
