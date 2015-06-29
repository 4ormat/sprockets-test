require 'rubygems'
require 'bundler/setup'
require 'byebug'
require './foo.rb'
foo = Foo.new
byebug
nil

# foo.precompile