require 'rubygems'
require 'bundler/setup'
require './foo.rb'

desc "precompile"
task :precompile do
  foo = Foo.new
  foo.precompile
end

desc "clean"
task :clean do
  foo = Foo.new
  foo.clean
end

desc "clobber"
task :clobber do
  foo = Foo.new
  foo.clobber
end