require 'chefspec'

describe 'osquery-pkg::default' do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

  it 'installs foo' do
    expect { chef_run }.not_to raise_error
  end
end
