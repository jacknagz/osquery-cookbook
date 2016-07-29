require 'chefspec'
require 'chefspec/berkshelf'

at_exit { ChefSpec::Coverage.report! }

RSpec.configure do |config|
  config.file_cache_path = '/var/chef/cache'
  config.log_level = :warn
  config.color = true
end

shared_context 'converged recipe' do
  let(:chef_run) do
    runner = ChefSpec::SoloRunner.new(node_attributes)
    runner.converge(described_recipe)
  end

  let(:node_attributes) do
    {}
  end

  let(:node) do
    chef_run.node
  end

  def attribute(name)
    node[described_cookbook][name]
  end
end
