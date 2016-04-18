require 'spec_helper'

describe 'osquery::centos' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos',
                             version: '7.0',
                             step_into: ['osquery_conf']
                            ) do |node|
      node.set['osquery']['packs'] = %w(centos_pack)
    end.converge(described_recipe)
  end

  let(:repo) { 'osquery-s3-centos7-repo-1-0.0.noarch.rpm' }

  it 'converges without error' do
    expect { chef_run }.not_to raise_error
  end

  it 'installs osquery package' do
    expect(chef_run).to install_package('osquery')
  end

  it 'installs the centos pack via lwrp' do
    expect(chef_run)
      .to create_cookbook_file('/usr/share/osquery/packs/centos_pack.conf')
  end

  it 'creates osquery conf via lwrp' do
    expect(chef_run)
      .to create_template('/etc/osquery/osquery.conf')
  end

  it 'install osquery repo' do
    expect(chef_run).to_not install_rpm_package('osquery repo')
  end

  it 'get osquery repo' do
    expect(chef_run).to create_remote_file("#{Chef::Config['file_cache_path']}/#{repo}")
  end

  it 'creates directory if its missing' do
    expect(chef_run).to create_directory('/usr/share/osquery/packs')
  end

  it 'creates osquery config' do
    expect(chef_run).to create_osquery_config('/etc/osquery/osquery.conf')
  end

  it 'starts and enables osquery service' do
    expect(chef_run).to enable_service('osqueryd')
    expect(chef_run).to start_service('osqueryd')
  end
end
