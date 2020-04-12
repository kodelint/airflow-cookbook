name 'airflow-cookbook'
maintainer 'Satyajit Roy'
maintainer_email 'kodelint@gmail.com'
license 'All Rights Reserved'
description 'Installs/Configures airflow-cookbook'
version '0.1.1'
chef_version '>= 14.0'

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
# issues_url 'https://github.com/kodelint/airflow-cookbook/issues'

# The `source_url` points to the development repository for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
# source_url 'https://github.com/kodelint/airflow-cookbook'

supports         'ubuntu', '= 18.04'
supports         'centos', '= 7.0'

depends 'apt'
depends 'yum-ius'
