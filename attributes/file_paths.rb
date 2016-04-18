# FIM configuration.
default['osquery']['file_paths'] = {
  homes: [
    '/home/%/.ssh/%%'
  ],
  etc: [
    '/etc/%%'
  ],
  tmp: [
    '/tmp/%%'
  ]
}
