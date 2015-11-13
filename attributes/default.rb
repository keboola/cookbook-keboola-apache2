

default['apache']['user'] = 'apache'
default['apache']['version'] = '2.4'
default['apache']['package'] = 'httpd24'
default['apache']['default_modules'] = %w[
  dir env mime negotiation setenvif
  status alias auth_basic authn_core authn_file authz_core authz_groupfile
  authz_host authz_user autoindex dir env mime negotiation setenvif logio log_config unixd socache_shmcb filter
]


default['apache']['prefork']['startservers']        = 5
default['apache']['prefork']['minspareservers']     = 5
default['apache']['prefork']['maxspareservers']     = 10
default['apache']['prefork']['serverlimit']         = 256
default['apache']['prefork']['maxrequestworkers']   = 256
default['apache']['prefork']['maxconnectionsperchild'] = 10_000
