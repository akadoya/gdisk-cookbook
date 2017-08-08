#
# Cookbook:: gdisk
# Recipe:: default
#
# Copyright:: 2017, Aoi Kadoya, All Rights Reserved.
#

chef_gem 'filesize' do
  compile_time true if Chef::Resource::ChefGem.method_defined?(:compile_time)
  action :install
end

package 'gdisk' do
  action :install
end

package 'parted' do
  action :install
end

