#
# Cookbook:: airflow-cookbook
# Recipe:: post_setup
#
# Copyright:: 2020, Satyajit, All Rights Reserved.

airflow_binary = "#{node['airflow']['bin_path']}/airflow"

execute 'run upgradedb' do
  command "cd #{node['airflow']['user_home_directory']}; su - #{node['airflow']['user']} -c '#{airflow_binary} upgradedb'"
  action :run
end

########################################
#      Create Airflow Admin User       #
########################################

execute 'Create AdminUser' do
  command "su - #{node['airflow']['user']} -c '#{airflow_binary} create_user -r #{node['airflow']['admin']['role']} -u #{node['airflow']['admin']['user']} -f #{node['airflow']['admin']['fistname']} -l #{node['airflow']['admin']['lastname']} -e #{node['airflow']['admin']['email']} -p #{node['airflow']['admin']['password']}'"
  action :run
  only_if { node['airflow']['config']['webserver']['rbac'] == 'True' }
end

###########################################
#     Create connections for Airflow      #
###########################################

node['airflow']['bootstrap']['connections'].each do |connection, connection_type|
  execute 'create connection' do
    command "su - #{node['airflow']['user']} -c '#{airflow_binary} connections --add --conn_id #{connection} --conn_type #{connection_type} --conn_extra {}'"
  end
end