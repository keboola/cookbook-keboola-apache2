#
# Cookbook Name:: keboola-apache2
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


file "#{node['apache']['dir']}/conf.d/autoindex.conf" do
  action :delete
  backup false
end

user "apache" do
  gid "apache"
end

include_recipe "aws"
include_recipe "apache2"

# apache2 cookbook fix (runs service[packageName] -> httpd24)
r = resources(service: 'apache2')
r.service_name('httpd')


apache_default_template = resources(:template => "apache2.conf")
apache_default_template.cookbook "keboola-apache2"


apache_sysconfig_template = resources(:template => "/etc/sysconfig/#{node['apache']['package']}")
apache_sysconfig_template.cookbook "keboola-apache2"


## PHP module
file "#{node['apache']['dir']}/conf.d/php.conf" do
  action :delete
  backup false
end

apache_module 'php5' do
  conf true
  filename 'libphp-5.6.so'
end

directory "/www" do
  owner "root"
  group "root"
  mode 0555
  action :create
end
