#
# Cookbook:: airflow-cookbook
# Recipe:: post_setup
#
# Copyright:: 2020, Satyajit, All Rights Reserved.

########################################
#      Create Airflow Admin User       #
########################################

execute 'Create AdminUser' do
  command node['airflow']['bootstrap']['create_admin_user_cmd']
  action :run
  only_if { node['airflow']['config']['webserver']['rbac'] == 'True' }
end

###########################################
#     Create connections for Airflow      #
###########################################

node['airflow']['bootstrap']['connections'].each do |connection, connection_type|
  execute 'create connection' do
    command "su - #{node['airflow']['user']} -c '/usr/local/bin/airflow connections --add --conn_id #{connection} --conn_type #{connection_type} --conn_extra {}'"
  end
end