# frozen_string_literal: true

require 'spec_helper'

describe 'osquery::default' do
  context 'when os_x' do
    include_context 'converged recipe'

    let(:platform) do
      { platform: 'mac_os_x', version: '10.12' }
    end

    it 'includes mac os x installation recipe' do
      expect(chef_run).to include_recipe('osquery::mac_os_x')
    end

    it 'converges without error' do
      expect { chef_run }.not_to raise_error
    end
  end

  context 'when ubuntu' do
    include_context 'converged recipe'

    let(:platform) do
      { platform: 'ubuntu', version: '14.04' }
    end

    it 'includes ubuntu installation recipe' do
      expect(chef_run).to include_recipe('osquery::ubuntu')
    end

    it 'converges without error' do
      expect { chef_run }.not_to raise_error
    end
  end

  context 'when centos' do
    include_context 'converged recipe'

    let(:platform) do
      { platform: 'centos', version: '7.7.1908' }
    end

    it 'includes centos installation recipe' do
      expect(chef_run).to include_recipe('osquery::centos')
    end

    it 'converges without error' do
      expect { chef_run }.not_to raise_error
    end
  end

  context 'when redhat' do
    include_context 'converged recipe'

    let(:platform) do
      { platform: 'redhat', version: '7.6' }
    end

    it 'includes centos installation recipe' do
      expect(chef_run).to include_recipe('osquery::centos')
    end

    it 'converges without error' do
      expect { chef_run }.not_to raise_error
    end
  end

  context 'when amazon' do
    include_context 'converged recipe'

    let(:platform) do
      { platform: 'amazon', version: '2018.03' }
    end

    it 'includes amazon installation recipe' do
      expect(chef_run).to include_recipe('osquery::amazon')
    end

    it 'converges without error' do
      expect { chef_run }.not_to raise_error
    end
  end
end
