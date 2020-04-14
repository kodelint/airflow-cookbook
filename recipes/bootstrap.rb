#
# Cookbook:: airflow-cookbook
# Recipe:: bootstrap
#
# Copyright:: 2020, Satyajit, All Rights Reserved.

################################
#  For CentOS 7 and Python3.6  #
################################

yum_repository 'ius' do
  baseurl 'https://repo.ius.io/7/$basearch'
  description 'IUS Community Packages for Enterprise Linux 7 - $basearch'
  enabled true
  gpgcheck true
  gpgkey 'https://repo.ius.io/RPM-GPG-KEY-IUS-7'
  only_if { platform?('centos') && node['platform_version'].to_i == 7 }
end

################################
# Create Airflow user and Group#
################################

group node['airflow']['group'] do
  gid node['airflow']['group_gid']
end

user node['airflow']['user'] do
  comment 'Airflow user'
  uid node['airflow']['user_uid']
  gid node['airflow']['group_gid']
  home node['airflow']['user_home_directory']
  manage_home true
  shell node['airflow']['shell']
end

########################################
#         Select OS dependencies       #
########################################

platform = node['platform'].to_s

execute 'Add DeadSnake PPA for Python35' do
  command 'add-apt-repository -y ppa:deadsnakes/ppa; apt-get update'
  action :run
  only_if { platform?('ubuntu') }
end

dependencies_to_install = []
node['airflow']['dependencies'][platform]['default'].each do |dependency|
  dependencies_to_install << dependency
end

###############################################################
#        Select OS dependencies based on python version       #
###############################################################

if node['airflow']['base']['python'] == '3.5'
  node['airflow']['dependencies'][platform]['python35'].each do |dependency|
    dependencies_to_install << dependency
  end
else
  node['airflow']['dependencies'][platform]['python36'].each do |dependency|
    dependencies_to_install << dependency
  end
end

########################################
#     Install all OS dependencies      #
########################################

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

case node['airflow']['base']['python']
when '3.5'
  execute 'install airflow' do
    command "python3.5 -m pip install #{node['airflow']['airflow_package']}==#{node['airflow']['version']}"
    action :run
    not_if "python3.5 -m pip show apache-airflow==#{node['airflow']['version']}"
  end
when '3.6'
  execute 'install airflow' do
    command "python3.6 -m pip install #{node['airflow']['airflow_package']}==#{node['airflow']['version']}"
    action :run
    not_if "python3.6 -m pip show apache-airflow==#{node['airflow']['version']}"
  end
end



########################################
#      Required folder structure       #
########################################

directory node['airflow']['config']['core']['airflow_home'] do
  owner node['airflow']['user']
  group node['airflow']['group']
  mode node['airflow']['directories_mode']
  action :create
end

directory node['airflow']['config']['core']['dags_folder'] do
  owner node['airflow']['user']
  group node['airflow']['group']
  mode node['airflow']['directories_mode']
  action :create
end

directory node['airflow']['config']['core']['plugins_folder'] do
  owner node['airflow']['user']
  group node['airflow']['group']
  mode node['airflow']['directories_mode']
  action :create
end

directory node['airflow']['run_path'] do
  owner node['airflow']['user']
  group node['airflow']['group']
  mode node['airflow']['directories_mode']
  action :create
end

directory node['airflow']['log_path'] do
  owner node['airflow']['user']
  group node['airflow']['group']
  mode node['airflow']['directories_mode']
  action :create
end

########################################
#        Generate airflow.cfg          #
########################################

template "#{node['airflow']['config']['core']['airflow_home']}/airflow.cfg" do
  source 'airflow.cfg.erb'
  owner node['airflow']['user']
  group node['airflow']['group']
  mode node['airflow']['config_file_mode']
  variables(
    lazy do
      {
        config: node['airflow']['config'],
      }
    end
  )
end

########################################
#        Generate airflow env          #
########################################

template 'airflow_services_env' do
  source 'init_system/upstart/airflow-env.erb'
  path node['airflow']['env_path']
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    is_upstart: node['airflow']['is_upstart'],
    config: node['airflow']['config']
  )
end

  
