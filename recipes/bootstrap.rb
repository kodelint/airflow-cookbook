#
# Cookbook:: airflow-cookbook
# Recipe:: bootstrap
#
# Copyright:: 2020, Satyajit, All Rights Reserved.

################################
# Create Airflow user and Group#
################################

group node["airflow"]["group"] do
  gid node["airflow"]["group_gid"]
end

user node["airflow"]["user"] do
  comment "Airflow user"
  uid node["airflow"]["user_uid"]
  gid node["airflow"]["group_gid"]
  home node["airflow"]["user_home_directory"]
  manage_home true
  shell node["airflow"]["shell"]
end

########################################
#        Install OS dependencies       #
########################################

platform = node['platform'].to_s                                         # Obtain the current platform name in local variable `platform`
dependencies_to_install = []                                             # Get the OS Dependencies to install in array
node['airflow']['dependencies'][platform][:default].each do |dependency|
  dependencies_to_install << dependency
end

dependencies_to_install.each do |value|
  package_to_install = ''
  version_to_install = ''
  value.each do |key, val|
    if key.to_s == 'name'
      package_to_install = val
    else
      version_to_install = val
    end
  end
  package package_to_install do
    action  :install
    version version_to_install
  end
end

########################################
#      Install Airflow using pip       #
########################################

execute "install airflow" do
  command "python3.6 -m pip install #{node["airflow"]["airflow_package"]}==#{node["airflow"]["version"]}"
  action :run
  not_if "python3.6 -m pip show apache-airflow==#{node["airflow"]["version"]}"
end

########################################
#      Required folder structure       #
########################################

directory node["airflow"]["config"]["core"]["airflow_home"] do
  owner node["airflow"]["user"]
  group node["airflow"]["group"]
  mode node["airflow"]["directories_mode"]
  action :create
end

directory node["airflow"]["config"]["core"]["dags_folder"] do
  owner node["airflow"]["user"]
  group node["airflow"]["group"]
  mode node["airflow"]["directories_mode"]
  action :create
end

directory node["airflow"]["config"]["core"]["plugins_folder"] do
  owner node["airflow"]["user"]
  group node["airflow"]["group"]
  mode node["airflow"]["directories_mode"]
  action :create
end

directory node["airflow"]["run_path"] do
  owner node["airflow"]["user"]
  group node["airflow"]["group"]
  mode node["airflow"]["directories_mode"]
  action :create
end

directory node["airflow"]["log_path"] do
  owner node["airflow"]["user"]
  group node["airflow"]["group"]
  mode node["airflow"]["directories_mode"]
  action :create
end

########################################
#        Generate airflow.cfg          #
########################################

template "#{node["airflow"]["config"]["core"]["airflow_home"]}/airflow.cfg" do
  source "airflow.cfg.erb"
  owner node["airflow"]["user"]
  group node["airflow"]["group"]
  mode node["airflow"]["config_file_mode"]
  variables(
    lazy do
      {
        :config => node['airflow']['config']
      }
    end
  )
end

########################################
#        Generate airflow env          #
########################################

template "airflow_services_env" do
  source "init_system/upstart/airflow-env.erb"
  path node["airflow"]["env_path"]
  owner "root"
  group "root"
  mode "0644"
  variables({
    :is_upstart => node["airflow"]["is_upstart"],
    :config => node["airflow"]["config"]
  })
end

########################################
#      Create required Tables          #
########################################
# Run upgradedb or initdb
# Answer: Actually any
# https://medium.com/datareply/airflow-lesser-known-tips-tricks-and-best-practises-cf4d4a90f8f

execute "run upgradedb" do
    command "cd #{node["airflow"]["user_home_directory"]}; su - #{node["airflow"]["user"]} -c '/usr/local/bin/airflow upgradedb'"
    action :run
end

########################################
#          Create Connections          #
########################################

node["airflow"]["bootstrap"]["connections"].each do |connection, connection_type|
  execute 'create connection' do
    command "su - #{node["airflow"]["user"]} -c '/usr/local/bin/airflow connections --add --conn_id #{connection} --conn_type #{connection_type} --conn_extra {}'"
  end
end

