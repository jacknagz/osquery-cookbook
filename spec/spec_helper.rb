require 'chefspec'
require 'chefspec/berkshelf'

RSpec.configure do |config|
  # Specify the path for Chef Solo file cache path (default: nil)
  config.file_cache_path = '/var/chef/cache'

  # Specify the Chef log_level (default: :warn)
  config.log_level = :warn
end
