source :rubygems

group :development do
  gem 'guard'
  gem 'guard-livereload'
  gem 'guard-shell'
  gem 'guard-copy'
  
  case RUBY_PLATFORM
  when /mswin(?!ce)|mingw|cygwin|bccwin/
    gem 'rb-fchange'
    gem 'rb-notifu'
    gem 'win32console'
  when /linux/
    gem 'guard-coffeescript'
    gem 'guard-less'
    gem 'rb-inotify'
    gem 'libnotify'
  when  /darwin/
    gem 'guard-coffeescript'
    gem 'guard-less'
    gem 'rb-fsevent'
    gem 'growl'
    gem 'growl_notify'
    gem 'ruby-growl'
  end
end
