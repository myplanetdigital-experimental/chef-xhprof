#
# Cookbook Name:: xhprof
# Recipe:: default
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

include_recipe "php"
case node[:platform]
when "debian","ubuntu"
  if node['lsb']['codename'] === 'hardy'
    # only pecl package on hardy
    php_pear "xhprof" do
      preferred_state "beta"
    end
  else
    execute "apt-get update" do
      action :nothing
    end

    %w{python-software-properties pkg-config}.each do |pkg|
      package pkg
    end

    execute "add-apt-repository ppa:brianmercer/php5-xhprof" do
      not_if { File.exists?("/etc/apt/sources.list.d/xhprof.list") }
      notifies :run, resources("execute[apt-get update]"), :immediately
    end

    package "php5-xhprof"
  end

when "mac_os_x"
  package "xhprof"

  template "/usr/local/etc/php5/conf.d/xhprof.ini" do
    source "xhprof.ini.erb"
  end
end

