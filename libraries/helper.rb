module Gdisk
  module Helper
    include Chef::Mixin::ShellOut

    def nil_or_empty?(value)
      value.nil? || value.respond_to?(:empty?) && value.empty?
    end

    def run_sgdisk(arg)
      cmd = "sgdisk #{arg}"
      shell_out!(cmd)
      load_table()
    end

    def load_table
      return_value = { 'out' => '', 'err' => '' }
      begin
        result = shell_out!('partprobe')
        return_value['out'] = result.stdout
      rescue
        Chef::Log.warn("Failed to load the new partition table: #{result.stderr}")
        return_value['err'] = result.stderr
      end
    end

    def size_check_sector(diff, device)
      free_size = shell_out("sgdisk -p #{device} |grep free| awk \'{print $5}\'")
      unless free_size.stdout.to_i >= diff
        Chef::Application.fatal!('Not enough free space')
      end
    end

    def get_current_type(partition_num, device)
      end_line = shell_out("sgdisk -p #{device}|wc -l").stdout.to_i
      start_line = shell_out("sgdisk -p #{device}|grep -n Number").stdout.to_i
      filtered_line = end_line - start_line
      current_type = shell_out("sgdisk -p #{device} |tail -#{filtered_line}|awk \'$1 == #{partition_num} {print $6}\'")
      if nil_or_empty?(current_type.stderr)
        current_type.stdout.strip
      else
        Chef::Log.warn('Failed to get the current partition type.')
        '0000'
      end
    end

    def size_check_size(size, device)
      require 'filesize'
      cmd = shell_out("sgdisk -p #{device} |grep free| awk \'{print $7,$8}\'")
      free_size_raw = cmd.stdout.gsub(/[()]/, '')
      Chef::Log.info("freesize is #{free_size_raw}")
      free_size_kb = Filesize.from(free_size_raw).to_f('KiB')
      unless free_size_kb >= Filesize.from(size).to_f('KiB')
        Chef::Application.fatal!('Not enough free space')
      end
    end

    def create_partition(pt)
      options = ':'
      if nil_or_empty?(pt.start_sector)
        if nil_or_empty?(pt.size) && nil_or_empty?(pt.end_sector)
          # if all of start/end/size are null or empty, invalid
          Chef::Log.fatal('Invalid partition options. Neither of size or start/end sector specified.')
        elsif !nil_or_empty?(pt.size) && nil_or_empty?(pt.end_sector)
          # if both of start/end are empty, use +size
          desired_size = "#{pt.size}iB"
          size_check_size(desired_size, pt.device_name)
          options = "0:+#{pt.size}"
        else
          # otherwise use end - size
          desired_size = "#{pt.size}iB"
          size_check_size(desired_size, pt.device_name)
          options = "-#{pt.size}:#{pt.end_sector}"
        end
      elsif nil_or_empty?(pt.size) && nil_or_empty?(pt.end_sector)
        # if only start is specified, use all the available space
        options = "#{pt.start_sector}:0"
      elsif !nil_or_empty?(pt.size) && nil_or_empty?(pt.end_sector)
        # if start and size without end, use start + size
        desired_size = "#{pt.size}iB"
        size_check_size(desired_size, pt.device_name)
        options = "#{pt.start_sector}:+#{pt.size}"
      else
        # start/end specified or everything specified, use sectors
        unless nil_or_empty?(pt.size)
          Chef::Log.warn('Start and End sectors are spesified. Size parameter will be ignored.')
        end
        sector_diff = pt.end_sector - pt.start_sector
        size_check_sector(sector_diff, pt.device_name)
        options = "#{pt.start_sector}:#{pt.end_sector}"
      end
      unless nil_or_empty?(pt.partition_name)
        name_option = "-c #{pt.number}:#{pt.partition_name}"
      end
      run_sgdisk("-n #{pt.number}:#{options} -t #{pt.number}:#{pt.type} #{name_option} -g #{pt.device_name}")
    end

    def delete_partition(pt)
      run_sgdisk("-d #{pt.number} -g #{pt.device_name}")
    end

    def change_partition_type(pt)
      run_sgdisk("-t #{pt.type} #{pt.device_name}")
    end

  end
end
