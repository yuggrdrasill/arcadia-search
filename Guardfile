#!/bin/ruby

guard 'livereload' do
  watch(%r{public/.+\.(css|js|html)})
  watch(%r{public/php/application/controllers/.+\.(php)})
  watch(%r{public/php/application/helpers/.+\.(php)})
  watch(%r{public/php/application/models/.+\.(php)})
  watch(%r{public/php/application/views/.+\.(php)})
  watch(%r{public/php/application/libraries/.+\.(php)})
  watch(%r{public/php/application/core/.+\.(php)})
end

# case RUBY_PLATFORM
# when /mswin(?!ce)|mingw|cygwin|bccwin/
#   guard 'shell' do
#   watch(%r{(^app/style/.+\.less$)}) do |m|
#     `node node_modules/grunt/bin/grunt  --force --config grunt.coffee less`
#   end
#   watch(%r{test/unit/coffee/.+\.coffee}) do |m|
#     #`grunt  --force --config grunt.coffee coffee:test`
#     m.each do |v|
#       `node node_modules/coffee-script/bin/coffee -o test/unit -c #{v}`
#     end
#   end
#   watch(%r{app/coffee/.+\.coffee}) do |m|
#     #`node node_modules/grunt/bin/grunt --force --config grunt.coffee coffee:app`
#     m.each do |v|
#       `node node_modules/coffee-script/bin/coffee -b -o public/js -c #{v}`
#     end
#   end
# end
# when /linux|darwin/
#   guard 'less' ,:input => 'app/styles' ,:output =>'public/css'
#   guard 'coffeescript' , :input => 'app/coffee', :output => 'public/js' ,:bare => true do
#     watch(%r{app/coffee/.+\.coffee})
#   end
#   guard 'coffeescript' , :input => 'test/unit/coffee', :output => 'test/unit/' ,:bare => true do
#     watch(%r{test/unit/coffee/.+\.coffee})
#   end
#   guard 'coffeescript' , :input => 'test/e2e/',:bare => true
# end


# guard 'shell' do
#   watch(%r{app/(.*\.html|.*\.ico|.*\.png|.*\.gif|.*\.css|.*\.json)$}) do |m|
#     m.each do |v|
#       `cp #{v} public/#{$1}`
#       puts "execute cp #{v} public/#{$1}"
#     end
#   end
#   watch(%r{app/font/(.*)$}) do |m|
#     m.each do |v|
#       `cp #{v} public/font/#{$1}`
#       puts "execute cp #{v} public/font/#{$1}"
#     end
#   end
#   watch(%r{app/php/application/(.*)$}) do |m|
#     m.each do |v|
#       `cp #{v} public/php/application/#{$1}`
#       puts "execute:cp #{v} public/php/application/#{$1}"
#     end
#   end
# end

#guard :copy, :from => "app/partials/", :to => "public/partials/" , :mkpath => true, :glob  => :newest do
#  watch(%r{{^app/partials/.*$}})
#end

# guard :copy, :from => "app", :to => 'public' , :mkpath => :true  do
#   watch(%r{(^.+\.html$)})
#   #do |m|
#     #m.each do |v|
#       #puts v
#     #end
#   #end
#   watch(%r{(^.+\.php$)})
#   watch(%r{(^.+\.json$)})
#   watch(%r{(^.+\.htaccess$)})
#   watch(%r{(^.+\.(png|jpg|gif)$)})
# end

