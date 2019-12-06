# frozen_string_literal: true

# example schedule config.
default['osquery']['schedule']['info'] = {
  query: 'SELECT * FROM osquery_info;',
  interval: 86_400
}
