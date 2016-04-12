require 'spec_helper'

describe 'osquery::ubuntu' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.automatic['platform'] = 'ubuntu'
      node.automatic['platform_version'] = '14.04'
      node.set['osquery']['packs'] = %w(ir)
    end.converge(described_recipe)
  end

  let(:osquery_vers) { '1.7.0-1.ubuntu14' }

  it 'converges without error' do
    expect { chef_run }.not_to raise_error
  end

  it 'installs osquery package' do
    expect(chef_run).to install_package('osquery')
      .with(version: osquery_vers)
  end

  it 'installs the hardware-monitoring pack' do
    expect(chef_run)
      .to create_cookbook_file('/usr/share/osquery/packs/ir.conf')
  end

  it 'creates osquery config' do
    expect(chef_run).to create_osquery_config('/etc/osquery/osquery.conf')
  end

  it 'starts and enables osquery service' do
    expect(chef_run).to enable_service('osqueryd')
    expect(chef_run).to start_service('osqueryd')
  end

  it 'adds osquery apt repo' do
    expect(chef_run).to add_apt_repository('osquery')
  end
end
