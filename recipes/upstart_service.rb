#
# Cookbook Name:: statsd
# Recipe:: service
#
# Copyright 2014, Librato, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Install our init script.
template '/etc/init.d/statsd' do
  source 'upstart.conf.erb'
  mode 0755
  notifies :restart, 'service[statsd]', :delayed
end

# Set up our service.
#service "statsd" do
#  supports :restart => true, :start => true, :stop => true, :reload => true, :status => true
#  action :nothing
#end 

# Set up our service.
supervisor_service "statsd" do
  command "su -s /bin/sh -c 'exec "$0" "$@"' #{node['statsd']['user']} -- $(which node) stats.js #{node['statsd']['config_dir']}/config.js 2>&1 >> #{node['statsd']['log_file']}"
  #command "#{node['statsd']['path']}/node_modules/aws-kcl/bin/kcl-bootstrap -e -p ./properties/clicks-quickstats.properties --java /usr/bin/java"
  process_name "statsds_%(process_num)s"
  numprocs 1
  autorestart true
  autostart true
  stopasgroup true
  directory "#{node['statsd']['path']}"
  startsecs 20
  stderr_logfile "/var/log/statsd_stderr.log"
  stdout_logfile "/var/log/statsd_stdout.log"
  action :enable
end
