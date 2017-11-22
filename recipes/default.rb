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
  manage_home true
  home '/home/apache'
end

directory '/home/apache' do
  owner 'apache'
  group 'apache'
  mode '0755'
  action :create
end

include_recipe "aws"
include_recipe "apache2"

# apache2 cookbook fix (runs service[packageName] -> httpd24)
r = resources(service: 'apache2')
r.service_name('httpd')

# override commands, default service httpd start does not source /etc/sysconfig/httpd
service 'apache2' do
  service_name 'httpd'
  start_command '/etc/init.d/httpd start'
  reload_command '/etc/init.d/httpd restart'
  #restart_command '/etc/init.d/httpd restart'
  status_command '/etc/init.d/httpd status'
  stop_command '/etc/init.d/httpd stop'
  supports [:start, :restart, :reload, :status]
  action [:enable, :start]
  only_if "#{node['apache']['binary']} -t", :environment => { 'APACHE_LOG_DIR' => node['apache']['log_dir'] }, :timeout => 2
end




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

execute "set apache home" do
  command "echo \"HOME=/home/apache\" >> /etc/sysconfig/httpd"
  notifies :reload, 'service[apache2]', :delayed
end



