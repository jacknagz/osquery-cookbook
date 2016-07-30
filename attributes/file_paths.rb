# FIM configuration.
default['osquery']['fim_enabled'] = false
default['osquery']['file_paths'] = {
  homes: ['/home/%/.ssh/%%'],
  etc: ['/etc/%%'],
  tmp: ['/tmp/%%']
}
