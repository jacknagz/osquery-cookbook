# frozen_string_literal: true

require 'mixlib/shellout'

# helper methods for common case statements
module Osquery
  def os_version
    node['platform_version'].to_i
  end

  def osquery_daemon
    case node['platform']
    when 'mac_os_x'
      'com.facebook.osqueryd'
    when 'centos', 'ubuntu', 'redhat', 'amazon'
      'osqueryd'
    end
  end

  def osquery_s3
    'https://pkg.osquery.io'
  end

  def osquery_config_path
    case node['platform']
    when 'mac_os_x'
      '/var/osquery/osquery.conf'
    when 'centos', 'ubuntu', 'redhat', 'amazon'
      '/etc/osquery/osquery.conf'
    end
  end

  def osquery_packs_path
    case node['platform']
    when 'mac_os_x'
      '/var/osquery/packs'
    when 'centos', 'ubuntu', 'redhat', 'amazon'
      '/usr/share/osquery/packs'
    end
  end

  def osquery_file_group
    case node['platform']
    when 'mac_os_x'
      'wheel'
    when 'centos', 'ubuntu', 'redhat', 'amazon'
      'root'
    end
  end

  def file_cache
    Chef::Config['file_cache_path']
  end
end

Chef::Recipe.include Osquery
Chef::Resource.include Osquery
Chef::Provider.include Osquery
