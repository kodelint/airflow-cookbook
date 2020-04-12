#
# Cookbook:: airflow-cookbook
# Recipe:: default
#
# Copyright:: 2020, Satyajit Roy, All Rights Reserved.

include_recipe "apt::default"
include_recipe 'airflow-cookbook::bootstrap'
include_recipe 'airflow-cookbook::post_setup'
