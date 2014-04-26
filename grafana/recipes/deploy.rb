def update_config(path, key, value)
  command = <<-eos
    sed -i -E 's^(#{key}:\s*).+,^#{key}: "#{value}",^g' #{path}
  eos
  execute command
end

node[:deploy].each do |application, deploy|

  unless ::File.directory?(deploy[:release_path])
    Chef::Log.debug('Release directory does not exist, stopping configure.')
    next
  end

  config_path = "#{deploy[:release_path]}/src/config.js"

  file config_path do
    owner deploy[:user]
    group deploy[:group]
    mode 0755
    content ::File.open("#{deploy[:release_path]}/src/config.sample.js").read
    action :create
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
