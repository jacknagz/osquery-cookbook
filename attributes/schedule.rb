# Example schedule config.
default['osquery']['schedule'] = {
  info: {
    query: 'SELECT * FROM osquery_info;',
    interval: 86_400
  },
  file_events: {
    query: 'SELECT * FROM file_events;',
    removed: false,
    interval: 300
  }
}
