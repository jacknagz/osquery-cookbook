# frozen_string_literal: true

require 'spec_helper'

describe 'osquery::ubuntu' do
  include_context 'converged recipe'

  let(:node_attributes_extra) do
    {}
  end

  let(:node_attributes) do
    {
      'osquery' => {
        'version' => '2.3.0',
        'packs' => %w[chefspec]
      }
    }.merge(node_attributes_extra)
  end

  let(:platform) do
    { platform: 'ubuntu', version: '14.04', step_into: ['osquery_install'] }
  end

  before do
    allow_any_instance_of(Chef::Resource).to receive(:rsyslog_legacy).and_return(Chef::Version.new('7.4.4'))
  end

  it 'converges without error' do
    expect { chef_run }.not_to raise_error
  end

  context 'specific version' do
    it 'installs osquery' do
      expect(chef_run).to install_osquery_ubuntu('2.3.0')
    end

    it 'installs osquery package' do
      expect(chef_run).to install_package('osquery').with(version: '2.3.0-1.linux')
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
      expect(chef_run).to install_osquery_ubuntu('4.0.2')
    end

    it 'installs/upgrades osquery package' do
      expect(chef_run).to upgrade_package('osquery').with(version: '4.0.2-1.linux')
    end
  end

  it 'sets up syslog for osquery' do
    expect(chef_run).to create_osquery_syslog('/etc/rsyslog.d/60-osquery.conf')
  end

  it 'adds osquery apt repo' do
    expect(chef_run).to add_apt_repository('osquery')
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
