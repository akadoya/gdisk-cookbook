name 'gdisk'
maintainer 'Aoi Kadoya'
maintainer_email 'cadyan.aoi@gmail.com'
license 'Apache 2.0'
description 'Provides gdisk resource'
long_description 'Provides gdisk resource to partition disks'
version '0.1.4'
chef_version '>= 12.1' if respond_to?(:chef_version)

issues_url 'https://github.com/akadoya/gdisk-cookbook/issues'
source_url 'https://github.com/akadoya/gdisk-cookbook'

supports 'ubuntu', '= 16.04'
