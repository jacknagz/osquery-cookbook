# frozen_string_literal: true

# helper methods to setup installation
module OsqueryInstallerHelpers
  include Chef::Mixin::ShellOut

  def osquery_latest_version
    Chef::Version.new(node['osquery']['version'])
  end

  def osquery_current_version
    version = shell_out!('`which osqueryi` -version')
    return nil if version.stdout.empty?

    osquery = version.stdout.split("\n")[0]
    Chef::Version.new(osquery.scan(/\d.\d.\d/).first)
  end

  def rsyslog_legacy
    version = shell_out!('`which rsyslogd` -v')
    return nil unless version.stderr.empty?

    rsyslogd = version.stdout.split("\n")[0]
    rsyslogd.scan(/\d.\d.\d/).first.to_f < 7.0
  end

  def osx_upgradable
    return true if !File.exist?('/usr/local/bin/osqueryi') || osquery_current_version.nil?

    osquery_current_version < osquery_latest_version
  end

  def supported
    {
      mac_os_x: %w[10.13],
      ubuntu: %w[12.04 14.04 16.04],
      centos: %w[6.5 7.0],
      redhat: %w[6.5 7.0],
      amazon: %w[2018.03 2]
    }
  end

  def supported_platform_version
    current_version = Chef::Version.new(node['platform_version'].to_f)
    supported[node['platform'].to_sym].each do |version|
      required_version = Chef::Version.new(version.to_f)
      next unless required_version.major == current_version.major
      return true if required_version <= current_version
    end
  end

  def supported_platform
    supported.keys.include?(node['platform'].to_sym) &&
      supported_platform_version
  end

  def repo_hashes
    {
      ubuntu: {
        key: '1484120AC4E9F8A1A577AEEE97A80C63C9D8B80B'
      }
    }
  end

  def mac_os_x_pkg_hashes
    {
      '4.0.2' => '91932b1eb4a7d1ed684611f25686a5a72b7342b54ca20a990ac647ce6c42a381'
    }
  end
end

Chef::Recipe.include OsqueryInstallerHelpers
Chef::Resource.include OsqueryInstallerHelpers
Chef::Provider.include OsqueryInstallerHelpers
