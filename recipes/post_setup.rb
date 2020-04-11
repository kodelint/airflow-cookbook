#
# Cookbook:: airflow-cookbook
# Recipe:: post_setup
#
# Copyright:: 2020, Satyajit, All Rights Reserved.

########################################
#      Create Airflow Admin User       #
########################################

execute "Create AdminUser" do
    command node["airflow"]["bootstrap"]["create_admin_user_cmd"]
    action :run
    only_if { node["airflow"]["config"]["webserver"]["rbac"] == "True" }
end