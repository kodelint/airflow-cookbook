#
# Cookbook:: airflow-cookbook
# Recipe:: default
#
# Copyright:: 2020, Satyajit Roy, All Rights Reserved.

include_recipe "apt::default"
case node['platform']
when 'centos'
  platform_version = node['platform_version'].split('.')[0]
  include_recipe 'airflow-cookbook::centos-config' if platform_version == '7'
end
include_recipe "airflow-cookbook::bootstrap"
