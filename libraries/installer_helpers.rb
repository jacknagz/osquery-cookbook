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
    return true if osquery_current_version.nil?
    osquery_current_version < osquery_latest_version
  end

  def supported
    {
      mac_os_x: %w(10.10),
      ubuntu: %w(12.04 14.04 16.04),
      centos: %w(6.5 7.0),
      redhat: %w(6.5 7.0)
    }
  end

  def supported_platform_version
    current_version = Chef::Version.new(node['platform_version'])
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
      centos: {
        6 => '5960044255a51feda80df816fc6769c2bf4316a59fb439b50a367db52d870144',
        7 => '86fd64c84d78072e9ad4051afd29890ff6d854984ad5b16cd84d678cd1f7ec21'
      },
      ubuntu: {
        key: '1484120AC4E9F8A1A577AEEE97A80C63C9D8B80B'
      }
    }
  end

  def mac_os_x_pkg_hashes
    {
      '1.8.1' => '1a118c535d009e6837efeb17bd3f44c125d0c442e6f7f652925d864a125e9f06',
      '1.7.4' => '74dabf0a08f3ed321183fd07583a6ff49c7fd779e08d978a501014df7b073ecc'
    }
  end
end

Chef::Recipe.send(:include, OsqueryInstallerHelpers)
Chef::Resource.send(:include, OsqueryInstallerHelpers)
Chef::Provider.send(:include, OsqueryInstallerHelpers)
