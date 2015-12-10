require 'chefspec'
require 'chefspec/berkshelf'

RSpec.configure do |config|
  # Specify the path for Chef Solo to find cookbooks
  config.cookbook_path = '/var/cookbooks'

  # Specify the path for Chef Solo to find roles
  config.role_path = '/var/roles'

  # Specify the path for Chef Solo to find environments
  config.environment_path = '/var/environments'

  # Specify the path for Chef Solo file cache path (default: nil)
  config.file_cache_path = '/var/chef/cache'

  # Specify the Chef log_level (default: :warn)
  config.log_level = :debug

  # Specify the path to a local JSON file with Ohai data (default: nil)
  config.path = 'ohai.json'

  # Specify the operating platform to mock Ohai data from (default: nil)
  config.platform = 'mac_os_x'

  # Specify the operating version to mock Ohai data from (default: nil)
  config.version = '10.10'
end
