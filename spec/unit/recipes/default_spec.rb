require 'spec_helper'

describe 'osquery::default' do
  context 'when os_x' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'mac_os_x', version: '10.10') do |node|
        node.set['osquery']['packs'] = %w(osx_pack)
      end.converge(described_recipe)
    end

    before do
      stub_command('which git').and_return('/usr/bin/git')
    end

    it 'includes mac os x installation recipe' do
      expect(chef_run).to include_recipe('osquery::mac_os_x')
    end

    it 'converges without error' do
      expect { chef_run }.not_to raise_error
    end
  end

  context 'when ubuntu' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '14.04') do |node|
        node.set['osquery']['packs'] = %w(ubuntu_pack)
      end.converge(described_recipe)
    end

    it 'includes ubuntu installation recipe' do
      expect(chef_run).to include_recipe('osquery::ubuntu')
    end

    it 'converges without error' do
      expect { chef_run }.not_to raise_error
    end
  end

  context 'when centos' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: '7.0') do |node|
        node.set['osquery']['packs'] = %w(centos_pack)
      end.converge(described_recipe)
    end

    it 'includes centos installation recipe' do
      expect(chef_run).to include_recipe('osquery::centos')
    end

    it 'converges without error' do
      expect { chef_run }.not_to raise_error
    end
  end

  context 'when redhat' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'redhat', version: '7.0') do |node|
        node.set['osquery']['packs'] = %w(centos_pack)
      end.converge(described_recipe)
    end

    it 'includes centos installation recipe' do
      expect(chef_run).to include_recipe('osquery::centos')
    end

    it 'converges without error' do
      expect { chef_run }.not_to raise_error
    end
  end
end
