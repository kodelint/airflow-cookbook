#
# Cookbook:: airflow-cookbook
# Recipe:: centos-config
#
# Copyright:: 2020, Satyajit, All Rights Reserved.

####################################################
# CentOS 7 needs IUS Repo configured for python3.6 #
####################################################

execute "install upstream package" do
    command "yum install -y https://centos7.iuscommunity.org/ius-release.rpm"
    action :run
    not_if "rpm -qa |grep ius-release"
end

execute "run update" do
    command "yum update -y"
    action :run
end