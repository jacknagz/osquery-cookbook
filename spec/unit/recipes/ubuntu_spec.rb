require 'spec_helper'

describe 'osquery::ubuntu' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'ubuntu',
                             version: '14.04',
                             step_into: ['osquery_conf']
                            ) do |node|
      node.set['osquery']['packs'] = %w(ubuntu_pack)
    end.converge(described_recipe)
  end

  let(:osquery_vers) { '1.7.3-1.ubuntu14' }

  it 'converges without error' do
    expect { chef_run }.not_to raise_error
  end

  it 'installs osquery package' do
    expect(chef_run).to install_package('osquery')
      .with(version: osquery_vers)
  end

  it 'creates osquery config' do
    expect(chef_run).to create_osquery_config('/etc/osquery/osquery.conf')
  end

  it 'installs the ubuntu pack via lwrp' do
    expect(chef_run)
      .to create_cookbook_file('/usr/share/osquery/packs/ubuntu_pack.conf')
  end

  it 'starts and enables osquery service' do
    expect(chef_run).to enable_service('osqueryd')
    expect(chef_run).to start_service('osqueryd')
  end

  it 'adds osquery apt repo' do
    expect(chef_run).to add_apt_repository('osquery')
  end
end
