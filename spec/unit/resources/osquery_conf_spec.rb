# frozen_string_literal: true

require 'spec_helper'

describe 'osquery_spec::osquery_conf' do
  context 'ubuntu' do
    include_context 'converged recipe'

    let(:platform) do
      { platform: 'ubuntu', version: '14.04', step_into: %w[osquery_conf] }
    end

    it 'converges without error' do
      expect { chef_run }.not_to raise_error
    end

    it 'creates osquery config via lwrp' do
      expect(chef_run).to create_osquery_config('/etc/osquery/osquery.conf')
    end

    it 'creates osquery conf files' do
      expect(chef_run)
        .to create_template('/etc/osquery/osquery.conf')
        .with(group: 'root', user: 'root', mode: '0440', sensitive: true)
    end

    it 'creates packs directory if its missing' do
      expect(chef_run).to create_directory('/usr/share/osquery/packs')
        .with(mode: '0755')
    end

    it 'creates config directory if its missing' do
      expect(chef_run).to create_directory('/etc/osquery')
        .with(mode: '0755')
    end

    it 'installs the osquery_spec_test pack' do
      expect(chef_run)
        .to create_cookbook_file('/usr/share/osquery/packs/osquery_spec_test.conf')
        .with(group: 'root', user: 'root', mode: '0664')
    end

    it 'does not install the default pack' do
      expect(chef_run)
        .to_not create_cookbook_file('/usr/share/osquery/packs/osquery-monitoring.conf')
    end
  end

  context 'os x' do
    include_context 'converged recipe'

    let(:platform) do
      { platform: 'mac_os_x', version: '10.12', step_into: %w[osquery_conf] }
    end

    it 'creates config directory if its missing' do
      expect(chef_run).to create_directory('/var/osquery')
    end

    it 'installs the osquery_spec_test pack' do
      expect(chef_run)
        .to create_cookbook_file('/var/osquery/packs/osquery_spec_test.conf')
        .with(group: 'wheel', user: 'root')
    end
  end
end
