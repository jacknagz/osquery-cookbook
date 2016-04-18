# Example schedule config.
default['osquery']['schedule'] = {
  info: {
    query: 'SELECT * FROM osquery_info',
    interval: '86400'
  }
}
