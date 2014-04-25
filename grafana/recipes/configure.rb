def update_config(path, key, value)
  command = <<-eos
    sed -i -E 's^(#{key}:\s*).+,^#{key}: "#{value}",^g' #{path}
  eos
  execute command
end

node[:deploy].each do |application, deploy|

  config_path = "#{deploy[:deploy_to]}/current/src/config.js"
  sample_config_path = "#{deploy[:deploy_to]}/current/src/config.sample.js"

  file config_path do
    owner deploy[:user]
    group deploy[:group]
    mode 0755
    content ::File.open(sample_config_path).read
    action :create_if_missing
  end

  node[:grafana][:config].each do |key, value|
    update_config(config_path, key, value)
  end

  elasticsearch_ip = node[:opsworks][:layers]['elasticsearch'][:instances].values.first[:private_ip]
  update_config(config_path, "elasticsearch", "http://#{elasticsearch_ip}:9200")

end

