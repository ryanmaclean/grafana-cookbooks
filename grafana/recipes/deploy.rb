def update_config(path, key, value)
  command = <<-eos
    sed -i -E 's^(#{key}:\s*).+,^#{key}: "#{value}",^g' #{path}
  eos
  execute command
end

node[:deploy].each do |application, deploy|

  current_path = "#{deploy[:deploy_to]}/current"
  config_path = "#{current_path}/src/config.js"

  execute "cp src/config.sample.js src/config.js" do
    cwd current_path
    user deploy[:user]
    group deploy[:group]
  end

  node[:grafana][:config].each do |key, value|
    update_config(config_path, key, value)
  end

  elasticsearch_ip = node[:opsworks][:layers]['elasticsearch'][:instances].values.first[:private_ip]
  update_config(config_path, "elasticsearch", "http://#{elasticsearch_ip}:9200")

  execute "npm install" do
    cwd current_path
    user deploy[:user]
    group deploy[:group]
  end
  execute "./node_modules/.bin/grunt build" do
    cwd current_path
    user deploy[:user]
    group deploy[:group]
  end

  execute "cp src/config.js dist/config.js" do
    cwd current_path
    user deploy[:user]
    group deploy[:group]
  end

end
