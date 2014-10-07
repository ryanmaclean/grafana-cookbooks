node[:deploy].each do |application, deploy|

  current_path = "#{deploy[:deploy_to]}/current"
  config_path = "#{current_path}/src/config.js"

  elasticsearch_ip = node[:opsworks][:layers]['elasticsearch'][:instances].values.first[:private_ip]
  template config_path do
    mode '0744'
    owner deploy[:user]
    group deploy[:group]
    variables({
        :es_url => "http://#{elasticsearch_ip}:9200",
        :graphite_url => node[:grafana][:graphite_url],
        :default_route => node[:grafana][:default_route],
    })
  end

  execute "sudo su #{deploy[:user]} -c 'npm install'" do
    cwd current_path
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
