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

include_recipe "apache2"

# apache2 cookbook fix (runs service[packageName] -> httpd24)
r = resources(service: 'apache2')
r.service_name('httpd')


apache_default_template = resources(:template => "apache2.conf")
apache_default_template.cookbook "keboola-apache2"

unless node['apache']['listen_ports'].include?('443')
  node.set['apache']['listen_ports'] = node['apache']['listen_ports'] + ['443']
end

if platform_family?('rhel', 'fedora', 'suse')
  package 'mod24_ssl' do
    notifies :run, 'execute[generate-module-list]', :immediately
  end

  file "#{node['apache']['dir']}/conf.d/ssl.conf" do
    action :delete
    backup false
  end
end

template 'ssl_ports.conf' do
  path      "#{node['apache']['dir']}/ports.conf"
  source    'ports.conf.erb'
  mode      '0644'
  cookbook  'apache2'
  notifies  :restart, 'service[apache2]'
end

apache_module 'ssl' do
  conf true
  cookbook 'apache2'
end


apache_sysconfig_template = resources(:template => "/etc/sysconfig/#{node['apache']['package']}")
apache_sysconfig_template.cookbook "keboola-apache2"

execute "download certificaties from s3" do
  command "aws s3 cp s3://keboola-configs/certificates/ssl-keboola.com.tar.gz /tmp/ssl-keboola.com.tar.gz"
end

directory "#{node['apache']['dir']}/ssl" do
  owner "root"
  group "root"
  mode 00644
  action :create
end

execute "extract-certificates" do
  command "tar --strip 1 -C #{node['apache']['dir']}/ssl -xf  /tmp/ssl-keboola.com.tar.gz"
  user "root"
  group "root"
end

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
