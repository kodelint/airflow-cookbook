#
# Cookbook:: airflow-cookbook
# Recipe:: flower
#
# Copyright:: 2020, Satyajit, All Rights Reserved.

if node['airflow']['init_system'] == 'upstart'
  service_target = '/etc/init/airflow-flower.conf'
  service_template = 'init_system/upstart/airflow-flower.conf.erb'
elsif node['airflow']['init_system'] == 'systemd' && platform?('ubuntu')
  service_target = '/etc/systemd/system/airflow-flower.service'
  service_template = 'init_system/systemd/airflow-flower.service.erb'
else
  service_target = '/usr/lib/systemd/system/airflow-flower.service'
  service_template = 'init_system/systemd/airflow-flower.service.erb'
end

template service_target do
  source service_template
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    user: node['airflow']['user'],
    group: node['airflow']['group'],
    run_path: node['airflow']['run_path'],
    bin_path: node['airflow']['bin_path'],
    env_path: node['airflow']['env_path']
  )
end

service 'airflow-flower' do
  action [:enable]
end
