

default['apache']['user'] = 'apache'
default['apache']['version'] = '2.4'
default['apache']['package'] = 'httpd24'
default['apache']['default_modules'] = %w[
  dir env mime negotiation setenvif
  status alias auth_basic authn_core authn_file authz_core authz_groupfile
  authz_host authz_user autoindex dir env mime negotiation setenvif logio log_config unixd socache_shmcb filter
]

default['keboola-apache']['certificates-bucket'] = 'keboola-configs'
