#
# Cookbook:: gdisktest
# Recipe:: default
#
# Copyright:: 2017, Aoi Kadoya, All Rights Reserved.
#

include_recipe 'gdisk'

gdisk_partition 'Already Exists' do
  action :create
  device_name '/dev/sda'
  number 1
end

gdisk_partition 'Create by size' do
  action :create
  device_name '/dev/sda'
  number 3
  size '1K'
end

gdisk_partition 'Delete /dev/sda3' do
  action :delete
  device_name '/dev/sda'
  number 3
end

gdisk_partition 'Create a partition ends at the end of the disk' do
  action :create
  device_name '/dev/sda'
  number 7
  end_sector 0
  partition_name 'sample swap'
  size '1K'
end

gdisk_partition 'Change the type to swap' do
  action :change_type
  device_name '/dev/sda'
  number 7
  type '8200'
end




