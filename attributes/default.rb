# User configuration
default["airflow"]["airflow_package"] = 'apache-airflow[all]' # use 'airflow' for version <= 1.8.0
default["airflow"]["version"] = '1.10.10'
default["airflow"]["user"] = "airflow-user"
default["airflow"]["group"] = "airflow-user"
default["airflow"]["user_uid"] = 9999
default["airflow"]["group_gid"] = 9999
default["airflow"]["user_home_directory"] = "/home/#{node["airflow"]["user"]}"
default["airflow"]["shell"] = "/bin/bash"

# Admin User details
default["airflow"]["admin"]["fistname"] = "Airflow"
default["airflow"]["admin"]["lastname"] = "Admins"
default["airflow"]["admin"]["role"] = "Admin"
default["airflow"]["admin"]["email"] = "airflowadmins@example.com"
default["airflow"]["admin"]["user"] = "admin"
default["airflow"]["admin"]["password"] = "password"

# General config
default["airflow"]["directories_mode"] = "0775"
default["airflow"]["config_file_mode"] = "0644"
default["airflow"]["bin_path"] = "/usr/local/bin"
default["airflow"]["run_path"] = "/var/run/airflow"
default["airflow"]["log_path"] = "/var/log/airflow"
default["airflow"]["is_upstart"] = node["platform"] == "ubuntu" && node["platform_version"].to_f < 15.04
default["airflow"]["init_system"] = node["airflow"]["is_upstart"] ? "upstart" : "systemd"
default["airflow"]["env_path"] = node["platform_family"] == "debian" ? "/etc/default/airflow" : "/etc/sysconfig/airflow"

# Core
default["airflow"]["config"]["core"]["airflow_home"] = "#{node["airflow"]["user_home_directory"]}/airflow"
default["airflow"]["config"]["core"]["dags_folder"] = "#{node["airflow"]["config"]["core"]["airflow_home"]}/dags"
default["airflow"]["config"]["core"]["plugins_folder"] = "#{node["airflow"]["config"]["core"]["airflow_home"]}/plugins"
default["airflow"]["config"]["core"]["sql_alchemy_conn"] = "sqlite:///#{node["airflow"]["config"]["core"]["airflow_home"]}/airflow.db"
default["airflow"]["config"]["core"]["load_examples"] = "True"
default["airflow"]["config"]["core"]["load_default_connections"] = "True"
default["airflow"]["config"]["core"]["dags_are_paused_at_creation"] = "True"
default["airflow"]["config"]["core"]["parallelism"] = 32
default["airflow"]["config"]["core"]["dag_concurrency"] = 16
default["airflow"]["config"]["core"]["max_active_runs_per_dag"] = 16
default["airflow"]["config"]["core"]["fernet_key"] = "OKLNLK452hhihSTT-jCXX902QpRYp7hwUtpfQ--_S8zLRbRMwX8tr3dehnNU=" 

# Celery
default["airflow"]["config"]["celery"]["worker_concurrency"] = 16

# WebServer
default["airflow"]["config"]["webserver"]["rbac"] = "True"
default["airflow"]["config"]["webserver"]["authenticate"] = "True"
default["airflow"]["config"]["webserver"]["auth_backend"] = "airflow.contrib.auth.backends.password_auth"
default["airflow"]["config"]["webserver"]["access_logfile"] = "#{node["airflow"]["config"]["core"]["airflow_home"]}/logs/airflow_access.log"
default["airflow"]["config"]["webserver"]["error_logfile"] = "#{node["airflow"]["config"]["core"]["airflow_home"]}/logs/airflow_error.log"

# Logging
default["airflow"]["config"]["logging"]["base_log_folder"] = "#{node["airflow"]["config"]["core"]["airflow_home"]}/logs"
