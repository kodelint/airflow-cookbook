# Airflow Chef Cookbook

Installs and configures Airflow workflow management platform. More information about **Airflow** can be found here: [airflow](https://github.com/airbnb/airflow)

#### Supported Platforms
- Ubuntu (Tested on 18.04).
- CentOS (Tested on 7)

#### Testing
- Local testing using `kitchen-ci` and `vagrant`
- Testing on AWS EC2 `kitchen-ci` look at [kitchen.yml](./kitchen.yml)

#### Attributes
All to view or change attributes and packages are here:

|Settings  |  File name|
|--|--|
| attributes | [default.rb](./attributes/default.rb) |
| packages | [pkgs.rb](./attributes/pkgs.rb) |
| commands | [commands.rb](./attributes/commands.rb) |

#### Recipes
|Recipe Name| What it does  |
|--|--|
| [default.rb](recipes/default.rb) | Includes and runs recipes required to setup `airflow`|
| [bootstrap.rb](recipes/bootstrap.rb) | Install `OS Packages`, `airflow`, Configures `airflow`, Creates `Administrator` user |
| [web.rb](recipes/web.rb) | Configures `airflow webserver` and creates `systemd` or `upstart` services based on platofrom|
| [scheduler.rb](recipes/scheduler.rb) | Configures `airflow scheduler` and creates `systemd` or `upstart` services based on platofrom|
| [workers.rb](recipes/workers.rb) | Configures `airflow workers` and creates `systemd` or `upstart` services based on platofrom|
| [flower.rb](recipes/flower.rb) | Configures `flower` for monitoring `celery` on `airflow scheduler` and creates `systemd` or `upstart` services based on platofrom|
| [centos-config.rb](recipes/centos-config.rb) | Installs required `OS Packages` for `CentOS 7`|

#### Testing using `kitchen`
```
---
driver:
  name: vagrant

verifier:
  name: inspec

platforms:
  - name: ubuntu-18.04
  # - name: centos-7

suites:
  - name: airflow-cookbook
    provisioner:
      name: chef_zero
      log_level: <%= ENV['CHEF_LOG_LEVEL'] || "auto" %>
      product_name: chef
      product_version: 14.14 # Change it for different `chef-client` or remove it to use the latest
    driver:
      network:
        - ["forwarded_port", {guest: 8080, host: 8080}]
    run_list:
      - recipe[airflow-cookbook::default]
      - recipe[airflow-cookbook::web]
      - recipe[airflow-cookbook::scheduler]
      - recipe[airflow-cookbook::workers]
      - recipe[airflow-cookbook::post_setup]
    verifier:
      inspec_tests:
        - test/integration/default
    attributes:
```
#### Changes
Please look at the [CHANGELOG](./CHANGELOG.md) for more detailed view