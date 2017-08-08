#
# Cookbook:: gdisk
# Resource:: partition
#
# Copyright:: 2017, Aoi Kadoya, All Rights Reserved.
#

actions :create, :delete, :change_type
default_action :create

state_attrs :device_name,
            :number,
            :type

# options
attribute :device_name,   kind_of: String, name_attribute: true, required: true
attribute :number,        kind_of: Integer, required: true
attribute :type,          regex: /^\h\h\h\h$/, default: '8300'
attribute :start_sector,  kind_of: Integer
attribute :end_sector,    kind_of: Integer
attribute :size,          regex: /^\d+[KMGTP]$/
