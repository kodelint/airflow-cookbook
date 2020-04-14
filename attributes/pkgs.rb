# OS packages needed for the above python packages.
default['airflow']['dependencies'] =
  {
    ubuntu:
    {
      default: [{ name: 'python3-pip', version: '' },
                { name: 'libsasl2-dev', version: '' },
                { name: 'libmysqlclient-dev', version: '' },
                { name: 'postgresql-client', version: '' },
                { name: 'libpq-dev', version: '' },
                { name: 'libkrb5-dev', version: '' }],
      python35: [{ name: 'python3.5', version: '' },
                 { name: 'python3.5-dev', version: '' }]
    },
    centos:
    {
      default: [{ name: 'epel-release', version: '' },
                { name: 'gcc', version: '' },
                { name: 'gcc-c++', version: '' },
                { name: 'mariadb-devel', version: '' },
                { name: 'cyrus-sasl-devel', version: '' }],
      python35: [{ name: 'python35u-pip', version: '' },
                { name: 'python35u-devel', version: '' },],
      python36: [{ name: 'python36u', version: '' },
                { name: 'python36u-libs', version: '' },
                { name: 'python36u-devel', version: '' },
                { name: 'python36u-pip', version: '' }],
    },
  }
