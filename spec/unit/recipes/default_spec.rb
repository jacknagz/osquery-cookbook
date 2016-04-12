require 'spec_helper'

describe 'osquery::default' do
  context 'when os_x' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.automatic['platform'] = 'mac_os_x'
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
      ChefSpec::SoloRunner.new do |node|
        node.automatic['platform'] = 'ubuntu'
        node.set['osquery']['packs'] = %w(ir)
      end.converge(described_recipe)
    end

    it 'includes mac os x installation recipe' do
      expect(chef_run).to include_recipe('osquery::ubuntu')
    end

    it 'converges without error' do
      expect { chef_run }.not_to raise_error
    end
  end
end
