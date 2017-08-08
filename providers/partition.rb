#
# Cookbook:: gdisk
# Provider:: partition
#
# Copyright:: 2017, Aoi Kadoya, All Rights Reserved.

include Gdisk::Helper

use_inline_resources if defined?(use_inline_resources)

def whyrun_supported?
  true
end

action :create do
  partition_path = new_resource.device_name + new_resource.number.to_s
  # check if exists
  if ::File.exist?(partition_path)
    Chef::Log.warn('The target partition table already exists. Nothing will be changed.')
  else
    converge_by("Creating new partition #{new_resource.name}") do
      create_partition(new_resource)
    end
  end
end

action :delete do
  partition_path = new_resource.device_name + new_resource.number.to_s
  if ::File.exist?(partition_path)
    converge_by("Deleting a partition #{partition_path}") do
      delete_partition(new_resource)
    end
  end
end

action :change_type do
  partition_path = new_resource.device_name + new_resource.number.to_s
  type_now = get_current_type(new_resource.number, new_resource.device_name)
  if type_now.to_s != new_resource.type && ::File.exist?(partition_path)
    converge_by("Changing a partition type #{partition_path}:#{new_resource.type}") do
      change_partition_type(new_resource)
    end
  elsif type_now.to_s == new_resource.type && ::File.exist?(partition_path)
    Chef::Log.warn("#{type_now.to_s} is already set. Nothing to do.")
  else
    Chef::Log.warn('The target partition table not found. Nothing will be changed.')
  end
end
