# Airflow Commands
default["airflow"]["bootstrap"]["create_admin_user_cmd"] = "su - #{node["airflow"]["user"]} -c '/usr/local/bin/airflow create_user -r #{node["airflow"]["admin"]["role"]} -u #{node["airflow"]["admin"]["user"]} -f #{node["airflow"]["admin"]["fistname"]} -l #{node["airflow"]["admin"]["lastname"]} -e #{node["airflow"]["admin"]["email"]} -p #{node["airflow"]["admin"]["password"]}'" # Create Admin User
default["airflow"]["bootstrap"]["connections"] = {           # Create Connections, no connections by default
   'emr_default' => 'emr',
   'aws_default' => 'aws',
   's3_default' => 's3'
}
