def update_config(path, key, value)
  command = <<-eos
    sed -i -E 's^(#{key}:\s*).+,^#{key}: "#{value}",^g' #{path}
  eos
  execute command
end

node[:deploy].each do |application, deploy|

  config_path = "#{deploy[:release_path]}/src/config.js"

  execute "cp src/config.sample.js src/config.js" do
    cwd deploy[:release_path]
    user deploy[:user]
    group deploy[:group]
  end

  node[:grafana][:config].each do |key, value|
    update_config(config_path, key, value)
  end

  elasticsearch_ip = node[:opsworks][:layers]['elasticsearch'][:instances].values.first[:private_ip]
  update_config(config_path, "elasticsearch", "http://#{elasticsearch_ip}:9200")

  execute "npm install" do
    cwd deploy[:release_path]
  end
  execute "./node_modules/.bin/grunt build" do
    cwd deploy[:release_path]
  end

  file "#{deploy[:release_path]}/dist/config.js" do
    owner deploy[:user]
    group deploy[:group]
    mode 0755
    content ::File.open(config_path).read
    action :create
  end

end
