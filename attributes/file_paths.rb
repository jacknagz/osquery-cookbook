# FIM configuration.
default['osquery']['file_paths'] = {
  homes: [
    '/root/.ssh/%%',
    '/home/%/.ssh/%%'
  ],
  etc: [
    '/etc/%%'
  ],
  tmp: [
    '/tmp/%%'
  ]
}
