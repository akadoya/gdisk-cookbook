Description
===========

Provides gdisk_partition resource.
MBR partitions will be converted to GPT format.

Requirements
============

Platform:
- Ubuntu 16.04

Recipes
=======

default
-------

The default recipe will:

- install `filesize` gem used in `libraries/helper.rb`
- install `gdisk` and `parted` 


Usage
=====

Simply add `gdisk::default` recipe to the run_list for the node you want to manage the GPT partitions.
See the `gdisktest` recipe for examples.

Resources/Providers
===================

The following gems and packages are used by the custom resources and are installed by the default recipe:

- Gem : `filesize`
- Package : `gdisk`, `parted`

gdisk_partition
---------------

This resource creates a partition and changes the partition type.
MBR partitions will be converted to GPT format.

#### Attributes

| Attribute       | Type     | Description                                                                    |
|-----------------|:--------:|:-------------------------------------------------------------------------------|
| `device_name`   | `String` | *required* target device file path : `/dev/sda`                                |
| `number`        | `Integer`| *required* partition number : `1`                                              |
| `type`          | `String` | GPT partition type. valid types can be found by `sgdisk -L`. default: `8300`   |
| `size`          | `String` | Partition size (KMGPT) : `100M`                                                |
| `start_sector`  | `Integer`| starting sector for the target partition                                       |
| `end_sector`    | `Integer`| ending sector for the target partition                                         |
| `action`        | `String` | `:create`, `:delete` or `:change_type`                                         |

** Note **

When creating a new partition, you can specify the size or the starting/ending sectors.

- only size is specified : creates a partition from the default starting sector + size 
- both of starting and ending sectors are specified : partition between the exact sectors. size will be ignored.
- either starting or ending and size are specified : partition from starting sector + size or partition to ending sector - size

See the test cookbook for examples.

License and Author
==================

Author:: Aoi Kadoya

Copyright:: 2017, Aoi Kadoya

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
