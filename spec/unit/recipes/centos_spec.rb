require 'spec_helper'

describe 'osquery::centos' do
  include_context 'converged recipe'

  let(:node_attributes_extra) do
    {}
  end

  let(:node_attributes) do
    {
      'osquery' => {
        'packs' => %w[chefspec],
        'version' => '3.2.6'
      }
    }.merge(node_attributes_extra)
  end

  let(:platform) do
    { platform: 'centos', version: '7.7.1908', step_into: ['osquery_install'] }
  end

  let(:repo) { 'osquery-4.0.2-1.linux.x86_64.rpm' }

  before do
    allow_any_instance_of(Chef::Resource).to receive(:rsyslog_legacy).and_return(Chef::Version.new('7.4.4'))
  end

  it 'converges without error' do
    expect { chef_run }.not_to raise_error
  end

  context 'specific version' do
    it 'installs osquery' do
      expect(chef_run).to install_osquery_centos('3.2.6')
    end

    it 'installs osquery package' do
      expect(chef_run).to install_package('osquery').with(version: '3.2.6-1.linux')
    end
  end

  context 'upgrade' do
    let(:node_attributes_extra) do
      {
        'osquery' => {
          'repo' => {
            'package_upgrade' => true
          }
        }
      }
    end

    it 'installs osquery' do
      expect(chef_run).to install_osquery_centos('4.0.2')
    end

    it 'installs/upgrades osquery package' do
      expect(chef_run).to upgrade_package('osquery').with(version: '4.0.2-1.linux')
    end
  end

  it 'sets up syslog for osquery' do
    expect(chef_run).to create_osquery_syslog('/etc/rsyslog.d/60-osquery.conf')
  end

  it 'install osquery repo' do
    expect(chef_run).to_not install_rpm_package('osquery repo')
  end

  it 'get osquery repo' do
    expect(chef_run).to create_remote_file("#{Chef::Config['file_cache_path']}/#{repo}")
  end

  it 'creates osquery config' do
    expect(chef_run).to create_osquery_config('/etc/osquery/osquery.conf')
      .with(
        pack_source: 'osquery',
        packs: %w[chefspec],
        decorators: {}
      )
  end

  it 'starts and enables osquery service' do
    expect(chef_run).to enable_service('osqueryd')
    expect(chef_run).to start_service('osqueryd')
  end
end
