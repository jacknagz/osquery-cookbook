require 'spec_helper'

describe 'osquery::ubuntu' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      platform: 'ubuntu',
      version: '14.04',
      step_into: %w(osquery_conf osquery_syslog)
    ) do |node|
      node.set['osquery']['packs'] = %w(ubuntu_pack)
      node.set['osquery']['version'] = '1.7.3'
      node.set['osquery']['syslog']['enabled'] = true
      node.set['osquery']['syslog']['filename'] = '/etc/rsyslog.d/60-osquery.conf'
    end.converge(described_recipe)
  end

  let(:osquery_vers) { '1.7.3-1.ubuntu14' }

  before do
    stub_command('which rsyslogd').and_return('/usr/sbin/rsyslogd')
    stub_command('`which rsyslogd` -v ').and_return('rsyslogd 7.4.4 \n')
  end

  it 'converges without error' do
    expect { chef_run }.not_to raise_error
  end

  it 'installs osquery package' do
    expect(chef_run).to install_package('osquery')
      .with(version: osquery_vers)
  end

  it 'sets up syslog configuration' do
    expect(chef_run).to create_osquery_syslog('/etc/rsyslog.d/60-osquery.conf')
    expect(chef_run).to install_package('rsyslog')
    expect(chef_run.service('rsyslog')).to do_nothing
    expect(chef_run).to create_cookbook_file('/etc/rsyslog.d/60-osquery.conf')
  end

  it 'creates osquery config' do
    expect(chef_run).to create_osquery_config('/etc/osquery/osquery.conf')
  end

  it 'installs the ubuntu pack via lwrp' do
    expect(chef_run)
      .to create_cookbook_file('/usr/share/osquery/packs/ubuntu_pack.conf')
      .with(group: 'root', user: 'root')
  end

  it 'starts and enables osquery service' do
    expect(chef_run).to enable_service('osqueryd')
    expect(chef_run).to start_service('osqueryd')
  end

  it 'adds osquery apt repo' do
    expect(chef_run).to add_apt_repository('osquery')
  end
end
